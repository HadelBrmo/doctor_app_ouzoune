import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/Widgets/custom_otp.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../core/constants/app_colors.dart';
import '../forget_password_controller/verfiycodecontroller.dart';

class Code extends StatelessWidget {
  const Code({super.key});

  @override
  Widget build(BuildContext context) {
    VerfiyCodeController controller = Get.put(VerfiyCodeController());
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter Verification Code",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: context.height * 0.02),
                      Text(
                        "Enter the 6-digit code that we have sent via Email",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: context.height * 0.04),
                      CustomOtp(
                        onChanged: (code) {
                          print('OTP changed: $code');
                          controller.verify_code.value = code!;
                        },
                        onSubmit: (code) {
                          print('OTP submitted: $code');
                          controller.verify_code.value = code;
                        },
                        codeNumber: 6,
                        focusedBorderColor: AppColors.primaryGreen,
                        cursorColor: AppColors.lightGreen,
                        keyBoard: TextInputType.number,
                      ),
                      SizedBox(height: context.height * 0.05),
                      CustomButton(
                        color: AppColors.primaryGreen,
                        text: "Confirm",
                        onTap: controller.isLoading.value
                            ? () {}
                            : () {
                          controller.verifyCode();
                        },
                      )
                    ],
                  ),
                  if (controller.isLoading.value)
                      Container(
                        child: const Center(
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