import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as box;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  final GetStorage box = GetStorage();
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }
  void _loadSavedTheme() {
    try {
      isDarkMode.value = box.read('isDarkMode') ?? false;
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

      print(' Theme loaded: ${isDarkMode.value ? 'Dark' : 'Light'}');
    } catch (e) {
      print(' Error loading theme: $e');
      isDarkMode.value = false;
    }
  }

  void toggleTheme() {
    try {
      isDarkMode.toggle();
      box.write('isDarkMode', isDarkMode.value);
      Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

      Get.snackbar(
        'Theme Changed',
        isDarkMode.value ? 'Dark Mode Activated' : 'Light Mode Activated',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      print(' Theme changed to: ${isDarkMode.value ? 'Dark' : 'Light'}');
    } catch (e) {
      print(' Error toggling theme: $e');
      Get.snackbar('Error', 'Failed to change theme');
    }
  }
}