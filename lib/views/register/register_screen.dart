import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import 'package:ouzoun/views/register/register_controller.dart';
import 'package:ouzoun/views/register/widget/buildRegisterForm.dart';
import 'Widget/LocationPicker/locationPicker .dart';
import 'Widget/registerHelpers .dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: buildBody(context),
    );
  }
  Widget buildBody(BuildContext context) {
    return Obx(() =>
        buildRegisterForm(context));
  }


}