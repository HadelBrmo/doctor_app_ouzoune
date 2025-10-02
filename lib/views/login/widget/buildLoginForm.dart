import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import '../login_controller.dart';
import 'loginHelpers.dart';

class buildLogin {
  static Widget buildLoginForm(BuildContext context, GlobalKey<FormState> formKey, LoginController controller,
      ) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.05),
      child: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoginHelpers.buildHeader(context),
                LoginHelpers.buildEmailField(controller.emailController),
                SizedBox(height: context.height * 0.05),
                LoginHelpers.buildPasswordField(controller.passwordController),
                LoginHelpers.buildForgotPasswordLink(context),
                SizedBox(height: context.height * 0.08),
                LoginHelpers.buildLoginButton(controller, formKey),
                SizedBox(height: context.height * 0.15),
                LoginHelpers.buildRegisterLink(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}