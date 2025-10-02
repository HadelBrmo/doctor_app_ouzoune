// app_bindings.dart
import 'package:get/get.dart';
import 'package:ouzoun/views/homePage/HomePage_Controller/homePage_controller.dart';

import '../Widgets/custom_bottom_navigation_bar .dart';
import '../views/notification/notification_controller/notification_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => HomePageController(), fenix: true);
  }
}