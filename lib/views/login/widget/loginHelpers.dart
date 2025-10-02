import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/Widgets/custom_text_form_field.dart' hide CustomTextFormField;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../register/register_screen.dart';
import '../../setting/setting_screen/widget/settingHelper.dart';
import '../login_controller.dart';

class LoginHelpers {
  static Widget buildLoadingIndicator() {
    return Center(
      child: Lottie.asset(
          AppAssets.LoadingAnimation,
          fit: BoxFit.cover,
          repeat: true,
          width: 200,
          height: 200
      ),
    );
  }

  static Widget buildHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.height * 0.06),
        Text(
          "Log in".tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: context.height * 0.04),
        Text(
          "Log in to your account\n and then continue using this app".tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: context.height * 0.08),
      ],
    );
  }

  static Widget buildEmailField(TextEditingController controller) {
    return CustomTextFormField(
      prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
      validator: (val) => val?.isEmpty ?? true ? "Email must not be empty".tr : null,
      myController: controller,
      hintText: "Enter your Email".tr,
      obscureText: false,
    );
  }

  static Widget buildPasswordField(TextEditingController controller) {
    final isPasswordVisible = false.obs;

    return Obx(() => CustomTextFormField(
      prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
      suffixIcon: IconButton(
        icon: Icon(
          isPasswordVisible.value
              ? Icons.visibility_off
              : Icons.visibility,
          color: Colors.grey[500],
        ),
        onPressed: () {
          isPasswordVisible.value = !isPasswordVisible.value;

        },
      ),
      validator: (val) => val?.isEmpty ?? true ? "Password must not be empty".tr : null,
      obscureText: !isPasswordVisible.value,
      myController: controller,
      hintText: 'Enter Your Password'.tr,
    ));
  }

  static Widget buildForgotPasswordLink(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.chekEmail),
      child: Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(
          top: context.height * 0.01,
          bottom: context.height * 0.02,
        ),
        child: Text(
          "Forgot Password ?".tr,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: context.width * 0.03,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  static Widget buildLoginButton(LoginController controller, GlobalKey<FormState> formKey) {
    return Obx(
          () => CustomButton(
        onTap: () async {
          if (controller.isLoading.value) return;
          await controller.login(formKey);
        },
        text: controller.isLoading.value ? 'Loading...'.tr : 'Login'.tr,
        color: AppColors.primaryGreen,
      ),
    );
  }

  static Widget buildRegisterLink(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => Get.to(() => RegisterScreen()),
        child: Text.rich(
          TextSpan(children: [
            TextSpan(
              text: "Don't have an account ? ".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.width * 0.04,
                fontFamily: "Montserrat",
              ),
            ),
            TextSpan(
              text: "Register".tr,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: context.width * 0.04,
                fontFamily: "Montserrat",
              ),
            ),
          ]),
        ),
      ),
    );
  }
}