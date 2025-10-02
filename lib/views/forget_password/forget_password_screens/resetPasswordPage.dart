import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_text_form_field.dart' hide CustomTextFormField;
import '../forget_password_controller/resetpagecontroller.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResetPageController controller = Get.put(ResetPageController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.height * 0.1,
            horizontal: context.width * 0.06,
          ),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: context.height * 0.9,
              ),
              alignment: Alignment.center,
              child: Obx(() => Stack(
                children: [
                  Form(
                    key: controller.key,
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.key,
                          color: AppColors.primaryGreen,
                          size: context.width * 0.2,
                        ),
                        SizedBox(height: context.height * 0.03),
                        Text(
                          "Reset Password",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: context.height * 0.02),
                        Text(
                          "Please Reset your Password to Access\nOuzoun App ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: context.height * 0.05),
                        CustomTextFormField(
                          hintText: "Enter your Password",
                          suffixIcon: Icon(Icons.remove_red_eye_outlined),
                          obscureText: true,
                          myController: controller.reset_Password,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Password must not be empty".tr;
                            }
                            if (val.length < 8) {
                              return "Password must be at least 8 characters".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height * 0.05),
                        CustomTextFormField(
                          hintText: "Confirm your Password",
                          suffixIcon: Icon(Icons.remove_red_eye_outlined),
                          obscureText: true,
                          myController: controller.confirmResetPassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Confirm password must not be empty".tr;
                            }
                            if (val != controller.reset_Password.text) {
                              return "Passwords do not match".tr;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: context.height * 0.05),
                        CustomButton(
                          color: AppColors.primaryGreen,
                          text: "Done",
                          onTap: controller.isLoading.value
                              ? () {}
                              : () {
                            controller.resetPassword();
                          },
                        )
                      ],
                    ),
                  ),
                  if (controller.isLoading.value)
                       Container(

                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),

                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}