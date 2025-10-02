import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../Routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_services.dart';

class RateController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final noteController = TextEditingController();
  final assistantId = ''.obs;
  final selectedAssistantName = ''.obs;
  final assistantsList = <Map<String, dynamic>>[].obs;
  final rate = 0.obs;
  final isLoading = false.obs;
  final hasNoAssistants = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAssistants();
  }

  void selectAssistant(String id, String name) {
    assistantId.value = id;
    selectedAssistantName.value = name;
  }

  Future<void> submitRating() async {
    if (assistantId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an assistant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Please select an assistant',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      return;
    }

    if (rate.value == 0) {
      Get.snackbar(
        'Error',
        'Please select a rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Please select a rating',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      return;
    }

    try {
      isLoading.value = true;
      final token = GetStorage().read('auth_token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          titleText: Text(
            'Error',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Please login again',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
        return;
      }

      final response = await apiServices.submitRating(
        note: noteController.text,
        rate: rate.value,
        assistantId: assistantId.value,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Success',
          'Rating submitted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          titleText: Text(
            'Success',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Rating submitted successfully',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
        noteController.clear();
        rate.value = 0;
        assistantId.value = '';
      } else {
        throw Exception('Failed to submit rating: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      Get.snackbar(
        'Error',
        'Failed to submit rating: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Failed to submit rating: ${e.message}',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      print('Unexpected Error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'An unexpected error occurred',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAssistants() async {
    try {
      isLoading.value = true;
      hasNoAssistants.value = false;

      final token = GetStorage().read('auth_token');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          titleText: Text(
            'Error',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Please login again',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
        return;
      }

      final assistants = await apiServices.getAssistantsFromProcedures(token);

      if (assistants.isEmpty) {
        hasNoAssistants.value = true;
        Get.snackbar(
          'Info',
          'No assistants found in your procedures',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(15),
          titleText: Text(
            'Info',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'No assistants found in your procedures',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      } else {
        assistantsList.assignAll(assistants);
        print('Loaded ${assistantsList.length} assistants');
      }

    } on DioException catch (e) {
      print('Dio Error loading assistants: ${e.message}');
      Get.snackbar(
        'Error',
        'Failed to load assistants',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Failed to load assistants',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      print('Unexpected Error loading assistants: $e');
      Get.snackbar(
        'Error',
        'Failed to load assistants',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Failed to load assistants',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }


}