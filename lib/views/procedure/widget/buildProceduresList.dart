import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

import '../../../core/constants/app_images.dart';
import '../../../models/Implant_model.dart';
import '../../../models/assistant_model.dart';
import '../../../models/clinic_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import 'buildProcedureCard.dart';

Widget buildProceduresList() {
  final controller = Get.find<ProcedureController>();

  return Obx(() {
    if (controller.isLoading.value) {
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
    if (controller.proceduresList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No procedures found'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.fetchAllProcedures(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchAllProcedures();
      },
      child: ListView.builder(
        itemCount: controller.filteredProcedures.length,
        itemBuilder: (context, index) {
          final procedure = controller.filteredProcedures[index];
          return buildProcedureCard(procedure, context);
        },
      ),
    );
  });
}