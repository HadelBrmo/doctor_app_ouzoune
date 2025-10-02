import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'myProfile_controller.dart';

class EditProfileController extends GetxController {
  final MyProfileController profileController = Get.put(MyProfileController());

  final userName = RxString('');
  final email = RxString('');
  final phoneNumber = RxString('');
  final clinicName = RxString('');
  final clinicAddress = RxString('');
  final location = RxString('');
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final clinicLongitude = 0.0.obs;
  final clinicLatitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      print('   UserName: ${userName.value}');
      print('   Email: ${email.value}');
      print('   PhoneNumber: ${phoneNumber.value}');
      print('   ClinicName: ${clinicName.value}');
      print('   Address: ${clinicAddress.value}');
      print('   Longtitude: ${clinicLongitude.value}');
      print('   Latitude: ${clinicLatitude.value}');
      print('   Has Image: ${selectedImage.value != null}');

      final data = {
        'UserName': userName.value,
        'Email': email.value,
        'PhoneNumber': phoneNumber.value,
        'ClinicName': clinicName.value,
        'Address': clinicAddress.value,
        'Longtitude': clinicLongitude.value,
        'Latitude': clinicLatitude.value,
      };
      final response = await profileController.apiServices.updateMyProfile(
        data: data,
        profileImageFile: selectedImage.value,
      );

      if (response != null) {
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: AppColors.lightGreen,
          colorText: Colors.white,
        );
        await profileController.fetchProfileData();

        Get.back();
      } else {
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
    }
  }

  void updateLocation(LatLng coords, String address) {

    clinicLongitude.value = coords.longitude;
    clinicLatitude.value = coords.latitude;
    location.value = address;
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
      } else {
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
}