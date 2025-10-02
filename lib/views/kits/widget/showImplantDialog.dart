import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../../models/additionalTool_model.dart';
import '../Kits_Controller/kits_controller.dart';

void showImplantsDialog(BuildContext context) {
  final KitsController controller = Get.find<KitsController>();

  Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
          backgroundColor: Theme.of(context).colorScheme.background,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Obx(() {
                if (controller.selectedImplants.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('No implants selected')),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selected Implants',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    ...controller.selectedImplants.entries.map((entry) {
                      final implant = entry.value;
                      final implantId = entry.key;
                      final selectedToolIds = controller.selectedToolsForImplants[implantId] ?? [];
                      final toolNames = selectedToolIds.map((toolId) {
                        if (implant.kitId != null) {
                          final kitTools = controller.getToolsByKitId(implant.kitId!);
                          final tool = kitTools.firstWhereOrNull((t) => t.id == toolId);
                          if (tool != null) return tool.name ?? 'Unknown Tool';
                        }

                        final additionalTool = controller.additionalTools.firstWhereOrNull((t) => t.id == toolId);
                        if (additionalTool != null) return additionalTool.name ?? 'Unknown Tool';

                        return 'Unknown Tool';
                      }).toList();

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller.getImplantNameByKitId(implant.kitId ?? 0),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => controller.toggleImplantSelection(implantId, implant),
                                  ),
                                ],
                              ),
                              if (selectedToolIds.isNotEmpty) ...[
                                Divider(height: 20),
                                Text(
                                  'Selected Tools (${selectedToolIds.length}):',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: toolNames.map((toolName) => Chip(
                                    label: Text(toolName),
                                    backgroundColor: Theme.of(context).highlightColor,
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onTap: () => Get.back(),
                            text: 'Close',
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        barrierDismissible: true,
      );
  }