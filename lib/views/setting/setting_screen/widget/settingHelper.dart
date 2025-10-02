import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../Core/Services/media_query_service.dart';
import '../../../../Routes/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/services.dart';
import '../../../login/login_screen.dart';
import '../../../myProfile/myProfile_controller/myProfile_controller.dart';
import '../../setting_controller/setting_controller.dart';

final MyProfileController _controller = Get.put(MyProfileController());
final SettingController controller = Get.put(SettingController());

Widget buildAccountCard(BuildContext context) {
  return Obx(() => Card(
    color: AppColors.primaryGreen,
    margin: EdgeInsets.only(bottom: context.height * 0.03),
    child: Padding(
      padding: EdgeInsets.all(context.width * 0.04),
      child: Row(
        children: [
          _buildProfileAvatar(context),
          SizedBox(width: context.width * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.userName.value.isNotEmpty
                    ? _controller.userName.value
                    : 'hadeel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _controller.email.value.isNotEmpty
                    ? _controller.email.value
                    : 'hadel@ouzone.com',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),

            ],
          ),
        ],
      ),
    ),
  ));
}

Widget _buildProfileAvatar(BuildContext context) {
  return Obx(() {
    if (_controller.profileImagePath.value.isNotEmpty) {
      // إذا كانت هناك صورة بروفايل من السيرفر
      return CircleAvatar(
        radius: context.width * 0.1,
        backgroundImage: NetworkImage(_controller.profileImagePath.value),
        backgroundColor: AppColors.lightGreen,
      );
    } else if (_controller.selectedImage.value != null) {
      // إذا كانت هناك صورة مختارة حديثاً
      return CircleAvatar(
        radius: context.width * 0.1,
        backgroundImage: FileImage(_controller.selectedImage.value!),
        backgroundColor: AppColors.lightGreen,
      );
    } else {
      // إذا لم توجد صورة، نعرض أيقونة افتراضية
      return CircleAvatar(
        radius: context.width * 0.1,
        backgroundColor: AppColors.lightGreen,
        child: Icon(
          Icons.person,
          color: Colors.grey[300],
          size: context.width * 0.1,
        ),
      );
    }
  });
}

Widget buildSettingsSection(
    BuildContext context, {
      required String title,
      required IconData icon,
      required List<Widget> children,
    }) {return Card(
  margin: EdgeInsets.only(bottom: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      Divider(height: 1),
      ...children,
    ],
  ),
);}

Widget buildSettingItem(
    BuildContext context, {
      required IconData icon,
      required String title,
      String? value,
      Widget? trailing,
      Function()? onTap,
    }) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryGreen),
    title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    subtitle: value != null
        ? Text(value, style: Theme.of(context).textTheme.titleMedium)
        : null,
    trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryGreen),
    onTap: onTap,
  );
}

void changeLanguage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("choose languages",
          style:  Theme.of(context).textTheme.titleMedium
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("English",
                style:  Theme.of(context).textTheme.headlineSmall
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text("English",
                style:  Theme.of(context).textTheme.headlineSmall
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}

void changeTheme(BuildContext context) {
  controller.toggleTheme();
}

Future<void> logout(BuildContext context) async {
  final box = GetStorage();

  final confirm = await Get.dialog(
    AlertDialog(
      title: Center(
        child: Text(
          'Confirm logout',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(
          fontFamily: 'Montserrat',
        ),
        textAlign: TextAlign.center,
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
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
          ),
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    ),
  );

  if (confirm == true) {
    try {
      // محاولة العثور على AuthService
      AuthService authService;
      try {
        authService = Get.find<AuthService>();
        await authService.logout();
      } catch (e) {
        print('AuthService not found, proceeding with local logout: $e');
        // إذا لم يتم العثور على AuthService، نقوم بالتسجيل الخروج محليًا فقط
        await box.erase();
        Get.offAll(() => LoginScreen());
      }

      Get.snackbar(
        'Success',
        'You have been successfully logged out.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print('Logout error: $e');
      Get.snackbar(
        'Error',
        'An error occurred while logging out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

Future<void> deleteAccount() async {
  final ApiServices apiServices = Get.find<ApiServices>();
  final GetStorage box = GetStorage();

  try {
    bool confirmDelete = await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'.tr),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'.tr, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete != true) return;
    final response = await apiServices.deleteCurrentUserAccount();

    if (response.statusCode == 200 || response.statusCode == 204) {
      await box.erase();

      Get.offAllNamed(AppRoutes.register);

      Get.snackbar(
        'Success'.tr,
        'Account deleted successfully'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      String errorMessage = 'Failed to delete account';

      if (response.statusCode == 400) {
        errorMessage = 'Bad request - Please check your information';
      } else if (response.statusCode == 401) {
        errorMessage = 'Unauthorized - Please login again';
      } else if (response.statusCode == 403) {
        errorMessage = 'Forbidden - You don\'t have permission';
      } else if (response.statusCode == 404) {
        errorMessage = 'Account not found';
      } else if (response.statusCode! >= 500) {
        errorMessage = 'Server error - Please try again later';
      }

      if (response.data != null) {
        if (response.data is Map) {
          final errorData = response.data as Map<String, dynamic>;
          errorMessage = errorData['message']?.toString() ??
              errorData['error']?.toString() ??
              errorMessage;
        } else if (response.data is String) {
          errorMessage = response.data;
        }
      }

      Get.snackbar(
        'Error'.tr,
        errorMessage.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } on DioException catch (e) {
    String errorMessage = 'An error occurred while trying to delete your account';

    if (e.response != null) {
      errorMessage = 'Failed to delete account: ${e.response?.statusCode}';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          final errorData = e.response?.data as Map<String, dynamic>;
          errorMessage = errorData['message']?.toString() ??
              errorData['error']?.toString() ??
              errorMessage;
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        }
      }
    } else {
      errorMessage = 'Connection error: ${e.message}';
    }

    Get.snackbar(
      'Error'.tr,
      errorMessage.tr,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } catch (e) {
    Get.snackbar(
      'Error'.tr,
      'An unexpected error occurred: $e'.tr,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

