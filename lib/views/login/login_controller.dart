import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/services/api_services.dart';
import '../../Routes/app_routes.dart';
import '../../core/services/firebase_service.dart';
import '../register/register_controller.dart';

class LoginController extends GetxController {
  RegisterController controller=Get.put(RegisterController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  ApiServices apiServices = ApiServices();
  final FirebaseServices _firebaseService = Get.put(FirebaseServices());


  Future<void> login(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      isLoading(true);
      try {
        String? deviceToken = await FirebaseMessaging.instance.getToken();
        final response = await apiServices.loginUser(
          email: emailController.text,
          password: passwordController.text,
          deviceToken: deviceToken,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final token = response.data['token'];
          print("***********************************");
          print(token);
          final box = GetStorage();
          await box.write('user_token', token);
          await GetStorage().write('auth_token', token.toString());
          print("***************device taken ${deviceToken}");

          Get.snackbar(
            'Success',
            'Welcome doctor ${controller.nameController.text}',
            backgroundColor: Colors.grey,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );

          Get.offAllNamed(AppRoutes.homepage);
        } else {
          final errorMessage = response.data?.toString() ?? 'Login failed';
          Get.snackbar(
            'Error',
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } on DioException catch (e) {
        print('Dio Error: ${e.message}');
        print('Dio Response: ${e.response?.data}');

        final errorData = e.response?.data;
        String errorMessage = 'Login failed';

        if (errorData is List && errorData.isNotEmpty) {
          errorMessage = errorData[0]['description'] ?? 'Email or Password is Wrong';
        } else if (errorData is Map) {
          errorMessage = errorData['message'] ?? 'Email or Password is Wrong';
        } else if (errorData is String) {
          errorMessage = errorData;
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Email or Password is Wrong';
        }

        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        print('General Error: $e');
        Get.snackbar(
          'Error',
          'An unexpected error occurred',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill all fields correctly',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }



  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}