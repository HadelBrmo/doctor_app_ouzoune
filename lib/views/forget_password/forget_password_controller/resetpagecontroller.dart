import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/services/api_services.dart';

class ResetPageController extends GetxController {
  TextEditingController reset_Password = TextEditingController();
  TextEditingController confirmResetPassword = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  var isLoading = false.obs;
  ApiServices apiServices = Get.put(ApiServices());
  final box = GetStorage();

  Future<void> resetPassword() async {
    if (!key.currentState!.validate()) {
      return;
    }

    if (reset_Password.text != confirmResetPassword.text) {
      Get.snackbar('Error', 'Passwords do not match'.tr);
      return;
    }

    if (!_isPasswordStrong(reset_Password.text)) {
      Get.snackbar('Error', 'Password must be at least 8 characters with uppercase, lowercase, number and special character'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final token = box.read('resetToken');
      print(' Token from storage: $token');

      if (token == null) {
        Get.snackbar('Error', 'Session expired, please try again'.tr);
        isLoading.value = false;
        return;
      }

      final response = await apiServices.resetPassword(
        newPassword: reset_Password.text,
        confirmNewPassword: confirmResetPassword.text,
        token: token,
      );

      print('Full response: $response');

      final statusCode = response['statusCode'];
      final responseData = response['data'];
      final success = response['success'];

      if (statusCode == 200 || statusCode == 201) {
        if (success == true) {
          await box.remove('resetToken');
          Get.snackbar('Success', 'Password reset successfully'.tr);
          goToSuccessPage();
        } else {
          String errorMessage = 'Password reset failed';
          if (responseData is Map) {
            errorMessage = responseData['message'] ?? errorMessage;
          } else if (responseData is String) {
            errorMessage = responseData;
          }
          Get.snackbar('Error', errorMessage.tr);
        }
      } else if (statusCode == 500) {
        String serverMessage = 'Internal server error (500)';
        if (responseData is String && responseData.isNotEmpty) {
          serverMessage = responseData;
        } else if (responseData is Map) {
          serverMessage = responseData['message'] ?? serverMessage;
        }
        Get.snackbar('Server Error', serverMessage.tr);
      } else {
        Get.snackbar('Error', 'Request failed with status code: $statusCode'.tr);
      }
    } catch (e) {
      print(' Unexpected error: ${e.toString()}');
      Get.snackbar('Error', 'Unexpected error: ${e.toString()}'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  bool _isPasswordStrong(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  void goToSuccessPage() {
    Get.delete<ResetPageController>(force: true);
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    // reset_Password.dispose();
    // confirmResetPassword.dispose();
    super.onClose();
  }
}