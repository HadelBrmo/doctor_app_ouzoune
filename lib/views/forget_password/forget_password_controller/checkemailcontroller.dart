import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/core/services/api_services.dart';

class CheckEmailController extends GetxController {
  late TextEditingController checkEmail;
  var isLoading = false.obs;
  ApiServices apiServices = Get.put(ApiServices());

  @override
  void onInit() {
    super.onInit();
    checkEmail = TextEditingController();
  }

  void goToVerify(GlobalKey<FormState> formKey) async {
    print('Form key current state: ${formKey.currentState}');
    print('Form key widget: ${formKey.currentWidget}');

    if (formKey.currentState == null) {
      Get.snackbar('Error', 'Form not initialized properly'.tr);
      return;
    }

    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final response = await apiServices.checkEmail(checkEmail.text);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.toNamed(AppRoutes.code);
        } else if (response.statusCode == 404) {
          Get.snackbar('Error', 'Email not found'.tr);
        } else {
          Get.snackbar('Error', 'An error occurred: ${response.statusCode}'.tr);
        }
      } on DioException catch (e) {
        if (e.response != null) {
          Get.snackbar('Error', 'Server error: ${e.response?.statusCode}'.tr);
        } else {
          Get.snackbar('Error', 'Network error: ${e.message}'.tr);
        }
      } catch (e) {
        Get.snackbar('Error', 'Unexpected error: $e'.tr);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    checkEmail.dispose();
    super.onClose();
  }
}