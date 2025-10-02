import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/core/services/api_services.dart';

class VerfiyCodeController extends GetxController {
  var verify_code = ''.obs;
  var isLoading = false.obs;
  ApiServices apiServices = Get.put(ApiServices());
  final box = GetStorage();

  Future<void> verifyCode() async {
    print('Entered code: ${verify_code.value}');

    if (verify_code.isEmpty || verify_code.value.length != 6) {
      print('Code is empty or not 6 digits');
      Get.snackbar('Error', 'Please enter a valid 6-digit code'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final response = await apiServices.verifyCode(verify_code.value);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          final token = responseData['token'];
          print(token);
          await box.write('resetToken', token);

          Get.snackbar('Success', 'Code verified successfully'.tr);
          Get.toNamed(AppRoutes.resetpage);
        } else {
          Get.snackbar('Error', 'Invalid verification code'.tr);
        }
      } else {
        Get.snackbar('Error', 'Verification failed: ${response.statusCode}'.tr);
      }
    } catch (e) {
      Get.snackbar('Error', 'Verification error: $e'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}