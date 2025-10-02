import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ouzoun/views/register/Widget/registerHelpers%20.dart';

import '../register_controller.dart';

Widget buildRegisterForm(BuildContext context) {
  final RegisterController controller = Get.put(RegisterController());
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: context.width * 0.04,
      vertical: context.width * 0.03,
    ),
    child: ListView(
      children: [
        Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.height * 0.02),
              RegisterHelpers.buildImagePicker(context, controller),
              RegisterHelpers.buildHeader(context),
              RegisterHelpers.buildNameField(controller.nameController),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildClinicField(controller.clinicNameController),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildAddressField(controller.addressController),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildLocationField(controller),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildPhoneField(controller.phoneController),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildEmailField(controller.emailController),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildPasswordField(controller.passwordController),
              // RegisterHelpers.buildForgotPasswordLink(context),
              SizedBox(height: context.height * 0.02),
              RegisterHelpers.buildSignUpButton(controller,),
              SizedBox(height: context.height * 0.03),
              RegisterHelpers.buildLoginLink(context),
            ],
          ),
        ),
      ],
    ),
  );
}