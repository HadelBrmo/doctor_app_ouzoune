import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/views/homePage/homePage_screen/homePage_screen.dart';
import 'package:ouzoun/views/myProfile/myProfile_screen/myProfile_screen.dart';
import 'package:ouzoun/views/rate/rate_screen/rate_screen.dart';
import '../Core/Services/media_query_service.dart';
import '../Models/draw_item_model.dart';
import '../Routes/app_routes.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_images.dart';
import '../core/services/services.dart';
import '../views/about_us/about_us_screen.dart';
import '../views/notification/notification_screen/notification_screen.dart';
import '../views/procedure/procedure_screen/get_all_procedures.dart';
import '../views/setting/setting_screen/setting_screen.dart';
import 'custom_view_item_list.dart';


class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<DrawItemModel> items=[
    DrawItemModel(text: 'HOMEPAGE', icon: Icons.home, function: (){
      Get.to(HomePageScreen());
    }, ),
    DrawItemModel(text: 'NOTIFICATION', icon: Icons.notifications_active, function: (){
      Get.to(NotificationsScreen());
    }, ),
    DrawItemModel(text: 'MY PROFILE', icon: Icons.person,function: (){
      Get.to(MyProfileScreen());
    }),
    DrawItemModel(text: 'MY ORDER', icon: Icons.receipt_long,function: (){
      Get.to(ProceduresScreen());
    }),
    DrawItemModel(text: 'RATING', icon: Icons.star_rate_sharp,function: (){
      Get.to(RateScreen());
    }),

    DrawItemModel(text: 'SETTING', icon: Icons.settings,function: (){
      Get.to(SettingsScreen());
    }),

    DrawItemModel(
      text: 'LOGOUT',
      icon: Icons.logout,
      function: () async {
        final authService = Get.find<AuthService>();
        final box = GetStorage();
        final confirm = await Get.dialog(
          AlertDialog(
            title: Center(
              child: Text(
                'Confirm logout',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await authService.logout();
            await box.erase();
            Get.offAllNamed(AppRoutes.login);
            Get.snackbar(
              'Successfully',
              'You have been successfully logged out.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(15),
              titleText: Text(
                'Successfully',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              messageText: Text(
                'You have been successfully logged out.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            );
          } catch (e) {
            Get.snackbar(
              'Error',
              'An error occurred while logging out: ${e.toString()}',
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
                'An error occurred while logging out: ${e.toString()}',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            );
          }
        }
      },
    ),

  ];
//
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    _triggerItemAnimations();
  }

  void _triggerItemAnimations() {
    for (int i = 0; i < items.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          setState(() {
            items[i].animated = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.elasticOut,
              ),
            ),
            child: DrawerHeader(
              child:  Image.asset(
                AppAssets.onboarding3LightAndDarkBackground,
                 scale: 4.5,
              ),
            ),
          ),
          const SizedBox(height: 45),
          CustomViewItemList(items: items),
        ],
      ),
    );
  }
}