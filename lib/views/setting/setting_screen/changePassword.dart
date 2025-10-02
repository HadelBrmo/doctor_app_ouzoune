import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/Widgets/custom_text_form_field.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../setting_controller/changePasswordController .dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Obx(() => Stack(
        children: [
          // المحتوى الرئيسي
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.06,
              vertical: context.height * 0.02,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.key,
                    color: AppColors.primaryGreen,
                    size: context.width * 0.2,
                  ),
                  SizedBox(height: context.height * 0.03),
                  Text(
                    "Change Password",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: context.height * 0.02),
                  Text(
                    "Please change your Password to Access\nOuzoun App ",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: context.height * 0.05),

                  // Old Password
                  Obx(() => CustomTextFormField(
                    hintText: "Enter your old Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isOldPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        controller.toggleOldPasswordVisibility();
                      },
                    ),
                    obscureText: !controller.isOldPasswordVisible.value,
                    myController: controller.oldPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Password must not be empty".tr;
                      }
                      if (val.length < 8) {
                        return "Password must be at least 8 characters".tr;
                      }
                      return null;
                    },
                  )),
                  SizedBox(height: context.height * 0.04),

                  // New Password
                  Obx(() => CustomTextFormField(
                    hintText: "Enter your new Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        controller.toggleNewPasswordVisibility();
                      },
                    ),
                    obscureText: !controller.isNewPasswordVisible.value,
                    myController: controller.newPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "New password must not be empty".tr;
                      }
                      if (val.length < 8) {
                        return "Password must be at least 8 characters".tr;
                      }
                      if (!controller.isPasswordStrong(val)) {
                        return "Password must include uppercase, lowercase, number and special character".tr;
                      }
                      return null;
                    },
                  )),
                  SizedBox(height: context.height * 0.04),

                  // Confirm Password
                  Obx(() => CustomTextFormField(
                    hintText: "Confirm your new Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        controller.toggleConfirmPasswordVisibility();
                      },
                    ),
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    myController: controller.confirmPasswordController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Confirm password must not be empty".tr;
                      }
                      if (val != controller.newPasswordController.text) {
                        return "Passwords do not match".tr;
                      }
                      return null;
                    },
                  )),
                  SizedBox(height: context.height * 0.04),

                  // Change Password Button
                  CustomButton(
                    color: AppColors.primaryGreen,
                    text: 'Change Password'.tr,
                    onTap: controller.isLoading.value
                        ? (){}
                        : () {
                      if (controller.formKey.currentState!.validate()) {
                        if (controller.newPasswordController.text !=
                            controller.confirmPasswordController.text) {
                          Get.snackbar('Error', 'Passwords do not match'.tr);
                          return;
                        }
                        controller.changePassword();
                      }
                    },
                  ),
                  SizedBox(height: context.height * 0.05),
                ],
              ),
            ),
          ),

          if (controller.isLoading.value)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
        ],
      )),
    );
  }
}