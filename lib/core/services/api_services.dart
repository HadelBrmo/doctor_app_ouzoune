

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as dio;
import 'package:ouzoun/models/procedure_model.dart';
import '../../Routes/app_routes.dart';
import '../../models/Implant_model.dart';
import '../../models/additionalTool_model.dart';
import '../../models/kit_model.dart';
class ApiServices {
  final Dio dio = Dio();
  final GetStorage storage = GetStorage();
  static const String baseUrl = "http://ouzon.somee.com/api";
  final RxList<dynamic> notifications = <dynamic>[].obs;
  final RxBool isLoadingNotifications = false.obs;
  final RxString notificationsError = ''.obs;
  final RxBool isRefreshing = false.obs;
  Completer<void> refreshCompleter = Completer<void>();
  Timer? tokenRefreshTimer;

  ApiServices() {
    _setupDio();
    _startTokenRefreshTimer();
  }

  void _setupDio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = storage.read('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.path.contains('refresh')) {
          try {
            await _refreshToken();
            final newToken = storage.read('auth_token');
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final response = await dio.request(
              error.requestOptions.path,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
            );
            return handler.resolve(response);
          } catch (refreshError) {
            if (refreshError is DioException &&
                refreshError.response?.statusCode == 401) {
              _logout();
            }
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  void _startTokenRefreshTimer() {
    tokenRefreshTimer = Timer.periodic(const Duration(hours: 20), (timer) async {
      if (storage.read('auth_token') != null) {
        await _refreshToken();
      }
    });
  }

  Future<void> _refreshToken() async {
    if (isRefreshing.value) {
      await refreshCompleter.future;
      return;
    }

    isRefreshing.value = true;
    refreshCompleter.complete();

    try {
      final refreshToken = storage.read('refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await dio.post(
        '/users/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        await storage.write('auth_token', newAccessToken);
        await storage.write('refresh_token', newRefreshToken);
      }
    } catch (e) {
      _logout();
      rethrow;
    } finally {
      isRefreshing.value = false;
      refreshCompleter = Completer<void>();
    }
  }

  void _logout() {
    storage.remove('auth_token');
    storage.remove('refresh_token');
    Get.offAllNamed(AppRoutes.login);
  }

  Future<Response> registerUserWithImage({
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
    required String clinicName,
    required String address,
    required double longitude,
    required double latitude,
    File? ProfilePicture,
    String? deviceToken,
    String role = 'User',
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('userName', userName),
        MapEntry('email', email),
        MapEntry('password', password),
        MapEntry('phoneNumber', phoneNumber),
        MapEntry('clinicName', clinicName),
        MapEntry('address', address),
        MapEntry('longtitude', longitude.toString()),
        MapEntry('latitude', latitude.toString()),
        MapEntry('role', role),
        if (deviceToken != null) MapEntry('deviceToken', deviceToken),
      ]);
      if (ProfilePicture != null) {
        final String extension = _getFileExtension(ProfilePicture.path);
        final List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
        if (!allowedExtensions.contains(extension)) {
          throw Exception('Only ${allowedExtensions.join(', ')} files are allowed');
        }
        formData.files.add(MapEntry(
          'ProfilePicture',
          await MultipartFile.fromFile(
            ProfilePicture.path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.$extension',
            contentType: MediaType('image', extension == 'jpg' ? 'jpeg' : extension),
          ),
        ));
      }
      final response = await dio.post(
        "$baseUrl/users/register",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  String _getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  Future<Response> loginUser({required String email, required String password, String? deviceToken}) async {
    try {
      final response = await dio.post("$baseUrl/users/login",
        data: {
          'email': email,
          'password': password,
          'deviceToken': deviceToken,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];
        await storage.write('auth_token', accessToken);
        await storage.write('refresh_token', refreshToken);
      }
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  Future<Response> addProcedure(Map<String, dynamic> procedureData, {String? token}) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await dio.post(
        "$baseUrl/procedures",
        data: procedureData,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  Future<List<Procedure>> postFilteredProcedures({
    DateTime? from,
    DateTime? to,
    int? minNumberOfAssistants,
    int? maxNumberOfAssistants,
    String? doctorName,
    String? clinicName,
    String? clinicAddress,
    int? status,
    List<String>? requestBody,
    required String token,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (minNumberOfAssistants != null) queryParams['minNumberOfAssistants'] = minNumberOfAssistants;
      if (maxNumberOfAssistants != null) queryParams['maxNumberOfAssistants'] = maxNumberOfAssistants;
      if (doctorName != null && doctorName.isNotEmpty) queryParams['doctorName'] = doctorName;
      if (clinicName != null && clinicName.isNotEmpty) queryParams['clinicName'] = clinicName;
      if (clinicAddress != null && clinicAddress.isNotEmpty) queryParams['clinicAddress'] = clinicAddress;
      if (status != null && status > 0) queryParams['status'] = status;

      final response = await dio.post(
        '$baseUrl/procedures/FilteredProcedure',
        queryParameters: queryParams,
        data: requestBody ?? [],
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is List && response.data.isNotEmpty && response.data[0] is String) {
          return [];
        }
        if (response.data is List) {
          return (response.data as List).map((p) => Procedure.fromJson(p)).toList();
        }
        return [];
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.offAllNamed(AppRoutes.login);
        Get.snackbar('Session Expired', 'Please login again');
      } else {
        Get.snackbar('Error', e.response?.data.toString() ?? e.message!);
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> getProcedureDetails(int procedureId) async {
    try {
      final response = await dio.get(
        '$baseUrl/procedures/$procedureId',
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load procedure details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.offAllNamed(AppRoutes.login);
        throw Exception('Session expired, please login again');
      }
      throw Exception('Network error: ${e.message}');
    }
  }





  Future<List<Procedure>> getProceduresPaged({
    required int pageSize,
    required int pageNum,
    String? doctorId,
    String? assistantId,
  }) async {
    try {
      final token = storage.read('auth_token');
      final response = await dio.get(
        '$baseUrl/procedures/paged',
        queryParameters: {
          'pageSize': pageSize,
          'pageNum': pageNum,
          if (doctorId != null && doctorId.isNotEmpty) 'doctorId': doctorId,
          if (assistantId != null && assistantId.isNotEmpty) 'assistantId': assistantId,
        },
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data as List).map((item) => Procedure.fromJson(item)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load paged procedures: ${e.message}');
    }
  }





  Future<Response> changeProcedureStatus({
    required int procedureId,
    required int newStatus,
    required String token,
  }) async {
    try {
      final response = await dio.patch(
        '$baseUrl/procedures/ChangeStatus',
        data: {
          'procedureId': procedureId,
          'newStatus': newStatus,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final token = storage.read('auth_token');
      if (token == null) throw Exception('No authentication token found');

      final response = await dio.get(
        '$baseUrl/users/current',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load profile: ${e.message}');
    }
  }



  Future<Map<String, dynamic>?> updateMyProfile({
    required Map<String, dynamic> data,
    File? profileImageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'UserName': data['UserName'] ?? '',
        'Email': data['Email'] ?? '',
        'PhoneNumber': data['PhoneNumber'] ?? '',
        'ClinicName': data['ClinicName'] ?? '',
        'Address': data['Address'] ?? '',
        'Longtitude': data['Longtitude']?.toString() ?? '0',
        'Latitude': data['Latitude']?.toString() ?? '0',
        'Image': profileImageFile != null ? await MultipartFile.fromFile(profileImageFile.path) : '',
      });

      final token = storage.read('auth_token');

      final response = await dio.put(
        '$baseUrl/users/UpdateCurrentUserProfile',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': '*/*',
          },
        ),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AdditionalTool>> getAdditionalTools() async {
    try {
      final token = storage.read('auth_token');
      final response = await dio.get(
        'http://ouzon.somee.com/api/tools',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.data as List).map((tool) => AdditionalTool.fromJson(tool)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load tools: ${e.message}');
    }
  }



  Future<Response> submitRating({
    required String note,
    required int rate,
    required String assistantId,
    String? procedureId,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        "$baseUrl/Ratings",
        data: {
          "note": note,
          "rate": rate,
          "assistantId": assistantId,
          if (procedureId != null) "procedureId": procedureId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to submit rating');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<List<Map<String, dynamic>>> getAssistantsFromProcedures(String token) async {
    try {
      final response = await dio.post(
        "$baseUrl/procedures/FilteredProcedure",
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
        data: [],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is! List) return [];
        final procedures = response.data as List;
        final assistants = <Map<String, dynamic>>[];
        final Set<String> addedAssistantIds = {};

        for (var procedure in procedures) {
          if (procedure.containsKey('assistants')) {
            final procedureAssistants = procedure['assistants'];
            if (procedureAssistants is List) {
              for (var assistant in procedureAssistants) {
                if (assistant is Map) {
                  final assistantId = assistant['id']?.toString();
                  if (assistantId != null && assistantId.isNotEmpty && !addedAssistantIds.contains(assistantId)) {
                    assistants.add({'id': assistantId, 'name': assistant['userName']?.toString() ?? 'Unknown'});
                    addedAssistantIds.add(assistantId);
                  }
                }
              }
            }
          }
        }
        return assistants;
      } else {
        throw Exception('Failed to load procedures: ${response.statusCode}');
      }
    } on DioException catch (e) {
      rethrow;
    }
  }



  Future<List<Implant>> getImplants() async {
    try {
      final token = storage.read('auth_token');
      final response = await dio.get(
        '$baseUrl/implants',
        options: Options(headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : response.data['data'];
        return data.map((json) => Implant.fromJson(json)).toList();
      }
      throw Exception('Failed with status ${response.statusCode}');
    } on DioException catch (e) {
      throw e;
    }
  }

  Future<List<Kit>> getKits() async {
    try {
      final token = storage.read('auth_token');
      final response = await dio.get(
        '$baseUrl/kits',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return (response.data as List).map((json) => Kit.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception('Failed to load tools: ${e.message}');
    }
  }

  Future<Kit> getKitById(int kitId) async {
    try {
      final token = storage.read('auth_token');
      final response = await dio.get(
        '$baseUrl/kits/$kitId',
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 200) {
        return Kit.fromJson(response.data);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<Response> getCurrentUserNotifications() async {
    try {
      final authToken = storage.read('auth_token');
      if (authToken == null) throw Exception('Auth token is missing');

      final response = await dio.get(
        '$baseUrl/Notifications/CurrnetUserNotifications',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notifications.value = response.data;
        notifications.refresh();
      }
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  Future<void> refreshNotifications() async {
    await getCurrentUserNotifications();
  }

  Future<Response> deleteCurrentUserAccount() async {
    try {
      final token = storage.read('auth_token');
      if (token == null) throw Exception('No authentication token found');

      final response = await dio.delete(
        '$baseUrl/users/DeleteCurrentUserAccount',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      throw Exception('Failed to connect to the server: ${e.message}');
    }
  }

  Future<Response> checkEmail(String email) async {
    return await dio.post(
      '$baseUrl/users/ForgotPassword',
      data: {'email': email},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<Response> verifyCode(String code) async {
    return await dio.post(
      '$baseUrl/users/VerifyForgotPasswordOtp',
      data: {'code': code},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }

  Future<dynamic> resetPassword({
    required String newPassword,
    required String confirmNewPassword,
    required String token,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/ResetPassword',
        data: {
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
          'token': token,
        },
        options: Options(
          headers: {'accept': '*/*', 'Content-Type': 'application/json'},
          validateStatus: (status) => true,
        ),
      );

      return {
        'statusCode': response.statusCode,
        'data': response.data,
        'success': response.statusCode! >= 200 && response.statusCode! < 300,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          'statusCode': e.response!.statusCode,
          'data': e.response!.data,
          'success': false,
          'error': e.message,
        };
      }
      return {'success': false, 'error': e.message, 'statusCode': 0};
    }
  }


  Future<Response> changePassword({
    required String newPassword,
    required String confirmNewPassword,
    required String oldPassword,
  }) async {
    try {
      final token = storage.read('user_token');
      final response = await dio.put(
        '$baseUrl/users/ChangePassword',
        data: {
          'newPassword': newPassword,
          'confirmNewPassword': confirmNewPassword,
          'oldPassword': oldPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> updateProcedure(Map<String, dynamic> data, {String? token}) async {
    try {
      final response = await dio.patch(
        '${baseUrl}/procedures',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      rethrow;
    }
  }
}


