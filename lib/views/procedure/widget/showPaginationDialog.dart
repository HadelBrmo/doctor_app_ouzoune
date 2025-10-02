import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';

Future<void> showPaginationDialog(BuildContext context) async {
  final controller = Get.put(ProcedureController());
  final pageNumberController = TextEditingController(
      text: controller.currentPage.value.toString()
  );
  final pageSizeController = TextEditingController(
      text: controller.itemsPerPage.value.toString()
  );

  await Get.dialog(
    AlertDialog(
      title: Text('Pagination Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: pageNumberController,
            keyboardType: TextInputType.number,
            cursorColor: AppColors.primaryGreen,
            decoration: InputDecoration(
              labelText: 'Page Number',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
              ),
              labelStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: pageSizeController,
            keyboardType: TextInputType.number,
            cursorColor: AppColors.primaryGreen,
            decoration: InputDecoration(
              labelText: 'Items Per Page',

              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryGreen, width: 2),
              ),
              labelStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel',
          style: TextStyle(
            color: Colors.grey,
            fontFamily:'Montserrat',
          ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final pageNum = int.tryParse(pageNumberController.text) ?? 1;
            final pageSize = int.tryParse(pageSizeController.text) ?? 3;

            if (pageSize > 0 && pageNum > 0) {
              final ProcedureController controller = Get.find();


              String? doctorId;
              if (controller.selectedProcedure.value != null) {
                doctorId = controller.selectedProcedure.value!.doctor.id;
              } else if (controller.proceduresList.isNotEmpty) {
                doctorId = controller.proceduresList.first.doctor.id;
              }

              controller.itemsPerPage.value = pageSize;
              controller.currentPage.value = 1;

              await controller.fetchProceduresPaged(
                doctorId: doctorId,
              );

              Get.back();
            } else {
              Get.snackbar(
                'Error'.tr,
                'Please enter valid numbers greater than 0'.tr,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: Text(
            'Apply'.tr,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        )
  ],
    ),
  );
}