import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import '../Kits_Controller/kits_controller.dart';

void showSelectedToolsDialog(List<AdditionalTool> tools) {
  final int itemCount = tools.length;

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.7,
          minHeight: 200,
        ),
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'الأدوات المحددة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1),

            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: (itemCount > 4)
                      ? MediaQuery.of(Get.context!).size.height * 0.4
                      : double.infinity,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: (itemCount > 4)
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  itemCount: tools.length,
                  separatorBuilder: (context, index) => const Divider(height: 8, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final tool = tools[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "x${tool.quantity}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        tool.name ?? 'No Name',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.construction_outlined,
                        color: AppColors.primaryGreen,
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  minimumSize: const Size(120, 40),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}