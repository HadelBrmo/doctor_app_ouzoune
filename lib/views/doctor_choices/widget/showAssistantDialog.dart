import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../Doctor_choices_controller/doctor_choices_controller.dart';

void showAssistantsDialog(BuildContext context) {
  final DoctorChoicesController controller = Get.put(DoctorChoicesController());
  Get.dialog(
    AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.width * 0.05),
      ),
      title: Text(
        "Select Number of Assistants",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.primaryGreen,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Choose how many assistants you need (1-5)",
            style: TextStyle(
              fontSize: context.width * 0.035,
              fontFamily: 'Montserrat',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.025),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final number = index + 1;
              return GestureDetector(
                onTap: () => controller.selectAssistants(number),
                child: Container(
                  width: context.width * 0.1,
                  height: context.width * 0.1,
                  decoration: BoxDecoration(
                    color: controller.tempSelection.value == number
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primaryGreen,
                      width: context.width * 0.005,
                    ),
                    borderRadius: BorderRadius.circular(context.width * 0.025),
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        color: controller.tempSelection.value == number
                            ? AppColors.whiteBackground
                            : AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: context.width * 0.045,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )),
          SizedBox(height: context.height * 0.025),
          Obx(() => Text(
            controller.tempSelection.value > 0
                ? 'Selected: ${controller.tempSelection.value}'
                : 'Please select a number',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontFamily: 'Montserrat',
              fontSize: context.width * 0.035,
            ),
          )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.resetSelection();
            Get.back();
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: context.width * 0.035,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.width * 0.025),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
              vertical: context.height * 0.0125,
            ),
          ),
          onPressed: controller.tempSelection.value > 0
              ? () {
            controller.confirmSelection();
            Get.back();
          }
              : null,
          child: Text(
            "Confirm",
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.whiteBackground,
              fontSize: context.width * 0.035,
            ),
          ),
        )),
      ],
    ),
  );
}