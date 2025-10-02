import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Routes/app_routes.dart';

class AuthService extends GetxService {
  final Dio dio = Dio();
  final GetStorage storage = GetStorage();
  static const String baseUrl="http://ouzon.somee.com/api";

  final RxBool isLoggedIn = false.obs;
  final RxString authToken = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dio.options.baseUrl = baseUrl;
    loadAuthData();

  }

  void loadAuthData() {
    authToken.value = storage.read('auth_token') ?? '';
    isLoggedIn.value = authToken.isNotEmpty;
  }



  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 ||response.statusCode == 201 ) {
        final token = response.data['token'];
        _saveAuthData(token);
        Get.offAllNamed(AppRoutes.homepage);
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = _handleError(e);
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await dio.post(
        '$baseUrl/users/register',
        data: userData,
      );

      if (response.statusCode == 201) {
        final token = response.data['token'];
        _saveAuthData(token);
        Get.offAllNamed(AppRoutes.homepage);
        return true;
      }
      return false;
    } on DioException catch (e) {
      errorMessage.value = _handleError(e);
      return false;
    }
  }

  Future<void> logout() async {
    await storage.remove('auth_token');
    authToken.value = '';
    isLoggedIn.value = false;
    dio.options.headers.remove('Authorization');
    Get.offAllNamed(AppRoutes.login);
  }

  void _saveAuthData(String token) {
    storage.write('auth_token', token);
    authToken.value = token;
    isLoggedIn.value = true;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  String _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'Invalid credentials';
    } else if (e.response?.statusCode == 400) {
      return e.response?.data['message'] ?? 'Bad request';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else {
      return 'An error occurred. Please try again.';
    }
  }
}