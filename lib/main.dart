import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/views/setting/setting_controller/setting_controller.dart';
import 'package:ouzoun/views/splash/splash_screens/splash_screen.dart';
import 'binding/initialize_binding.dart';
import 'core/services/LocalNotificationService .dart';
import 'core/services/api_services.dart';
import 'core/services/firebase_service.dart';
import 'core/services/services.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'core/constants/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.init();

  await initializeServices();

  runApp(const MyApp());
}

Future<void> initializeServices() async {
  try {
    Get.put(ApiServices(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(SettingController(), permanent: true);
    await Get.putAsync(() => FirebaseServices().onInit(), permanent: true);
  } catch (e) {
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPages.pages,
      initialBinding: AppBindings(),
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      //main screen
      home: SplashScreen(),
    );
  }
}