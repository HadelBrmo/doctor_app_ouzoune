import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../core/constants/app_colors.dart';
class NavigationController extends GetxController {
final tabIndex = 2.obs;
final icons = [
Icons.star_rate_sharp,
Icons.person,
Icons.home,
Icons.receipt_long,
Icons.notifications_active,
];

final routes = [
'/rate',
'/profile',
'/homepage',
'/get_all_procedure',
'/notifications',
];
void changeIndex(int index) {
tabIndex.value = index;
Get.toNamed(routes[index]);
}
}

class CustomBottomNavigationBar extends StatelessWidget {
const CustomBottomNavigationBar({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
final controller = Get.put(NavigationController());


return Obx(() => AnimatedBottomNavigationBar.builder(
itemCount: controller.icons.length,
backgroundColor: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
gapLocation: GapLocation.none,
notchSmoothness: NotchSmoothness.softEdge,
tabBuilder: (int index, bool isActive) {
final color = isActive ? AppColors.primaryGreen : Colors.grey;
return Column(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
controller.icons[index],
color: color,
size: isActive ? 28 : 24,
),
if (isActive)
Container(
margin: const EdgeInsets.only(top: 4),
height: 3,
width: 20,
color: AppColors.primaryGreen,
),
],
);
},
activeIndex: controller.tabIndex.value,
onTap: (index) {
controller.changeIndex(index);
},
splashSpeedInMilliseconds: 300,
leftCornerRadius: 20,
rightCornerRadius: 20,
shadow: BoxShadow(
color: Colors.black12,
blurRadius: 10,
),
));
}
}