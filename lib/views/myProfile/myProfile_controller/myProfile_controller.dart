import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/api_services.dart';
import '../../register/Widget/LocationPicker/locationPicker_controller.dart';

class MyProfileController extends GetxController {
  final ApiServices apiServices = Get.put(ApiServices());
  final LocationPickerController locationController = Get.put(LocationPickerController());

  final id = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final phoneNumber = ''.obs;
  final role = 'User'.obs;
  final rate = 0.0.obs;
  final clinicId = 0.obs;
  final clinicName = ''.obs;
  final clinicAddress = ''.obs;
  final clinicLongitude = 0.0.obs;
  final clinicLatitude = 0.0.obs;
  final profileImagePath = ''.obs;
  var location = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isConvertingAddress = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.currentRoute == '/profile') {
      fetchProfileData();
    }
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading(true);

      final response = await apiServices.getMyProfile();

      if (response.isEmpty) {
        Get.snackbar(
          'Profile',
          'No profile data found',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      id.value = response['id'] ?? '';
      userName.value = response['userName'] ?? '';
      email.value = response['email'] ?? '';
      phoneNumber.value = response['phoneNumber'] ?? '';
      role.value = response['role'] ?? '';
      rate.value = (response['rate'] ?? 0.0).toDouble();
      profileImagePath.value = response['profileImagePath'] ?? '';
      final clinic = response['clinic'];
      if (clinic != null) {
        clinicId.value = clinic['id'] ?? 0;
        clinicName.value = clinic['name'] ?? '';
        clinicAddress.value = clinic['address'] ?? '';
        clinicLongitude.value = (clinic['longtitude'] ?? 0.0).toDouble();
        clinicLatitude.value = (clinic['latitude'] ?? 0.0).toDouble();
        await convertCoordinatesToAddress(
            clinicLatitude.value, clinicLongitude.value);
      }

    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.snackbar(
          'Authentication Error',
          'Session expired. Please login again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        Get.snackbar(
          'Network Error',
          'Connection timeout. Please check your internet',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Profile Error',
          'Network error: ${e.message ?? "Unknown error"}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Profile Error',
        'Failed to load profile data: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);

      final data = {
        'UserName': userName.value,
        'Email': email.value,
        'PhoneNumber': phoneNumber.value,
        'ClinicName': clinicName.value,
        'Address': clinicAddress.value,
        'Longtitude': clinicLongitude.value,
        'Latitude': clinicLatitude.value,
      };

      final response = await apiServices.updateMyProfile(
        data: data,
        profileImageFile: selectedImage.value,
      );

      if (response != null) {
        if (response['profileImagePath'] != null) {
          profileImagePath.value = response['profileImagePath'];
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchProfileData();

        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
      selectedImage.value = null;
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Image selected successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> convertCoordinatesToAddress(double latitude, double longitude) async {
    try {
      if (latitude == 0.0 && longitude == 0.0) {
        location.value = 'Location not set';
        return;
      }
      final latLng = LatLng(latitude, longitude);
      await locationController.onMapTapped(latLng);
      await Future.delayed(Duration(milliseconds: 500));
      location.value = locationController.locationName.value;
    } catch (e) {
      location.value = 'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }
}