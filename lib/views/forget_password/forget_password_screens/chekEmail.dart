import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import '../../../Widgets/custom_button.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_text_form_field.dart' hide CustomTextFormField;
import '../forget_password_controller/checkemailcontroller.dart';

class CheckEmail extends StatelessWidget {
  CheckEmail({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CheckEmailController controller = Get.put(CheckEmailController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.height * 0.05,
            horizontal: context.width * 0.06,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: context.width,
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
                      Icon(
                        FontAwesomeIcons.envelopeCircleCheck,
                        color: AppColors.primaryGreen,
                        size: context.width * 0.2,
                      ),
                      SizedBox(height: context.height * 0.03),
                      Text(
                        "Forget Password?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: context.height * 0.02),
                      Text(
                        "Please Enter your email to check\nif it is available ",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: context.height * 0.05),

                      Form(
                        key: formKey,
                        child: CustomTextFormField(
                          hintText: "Enter your Email",
                          suffixIcon: const Icon(Icons.email_outlined),
                          obscureText: false,
                          myController: controller.checkEmail,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email must not be empty".tr;
                            }
                            if (!GetUtils.isEmail(val)) {
                              return "Please enter a valid email".tr;
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: context.height * 0.05),
                      Obx(() => CustomButton(
                        color: AppColors.primaryGreen,
                        text: "Save",
                        onTap: controller.isLoading.value
                            ? () {}
                            : () {
                          controller.goToVerify(formKey);
                        },
                      )),
                      SizedBox(height: context.height * 0.05),
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