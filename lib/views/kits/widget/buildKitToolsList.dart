import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import '../Kits_Controller/kits_controller.dart';

List<Widget> buildKitToolsList(List<dynamic> tools, String implantId) {
  final KitsController controller = Get.find<KitsController>();
  return tools.map((tool) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Obx(() {
            final isSelected = controller.isToolSelectedForImplant(implantId, tool.id!);
            return Checkbox(
              checkColor: Colors.white,
              value: isSelected,
              onChanged: (value) {
                controller.toggleToolSelection(implantId, tool.id!);
              },
              activeColor: AppColors.primaryGreen,
            );
          }),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              tool.name ?? 'Unnamed Tool',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}

Widget buildSection(BuildContext context, {required String title, required List<Widget> children}) {
  return Column(
    children: [
      SizedBox(height: context.height * 0.03),
      Container(
        padding: EdgeInsets.all(context.width * 0.04),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: context.height * 0.01),
            Divider(color: AppColors.primaryGreen),
            SizedBox(height: context.height * 0.01),
            ...children,
          ],
        ),
      ),
    ],
  );
}