import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import 'package:ouzoun/models/additionalTool_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../../models/kit_model.dart';
import '../../../widgets/custom_button.dart';
import '../Kits_Controller/kits_controller.dart';
import '../widget/buildKitToolsList.dart';
import '../widget/buildSpecItem.dart';

class ImplantDetailScreen extends StatelessWidget {
  final Implant implant;

  final KitsController controller = Get.put(KitsController());

  ImplantDetailScreen({super.key, required this.implant});

  @override
  Widget build(BuildContext context) {
    final implantId = implant.id.toString();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final kitId = implant.kitId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kitId != null) {
        controller.fetchKitById(kitId);
      }
    });

    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: context.width * 0.5,
                    height: context.height * 0.16,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(context.width * 0.2),
                      ),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: EdgeInsets.all(context.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: context.width * 0.4,
                              height: context.width * 0.4,
                              decoration: BoxDecoration(
                               // color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: (implant.imagePath != null && implant.imagePath!.isNotEmpty)?
                              Image.network(
                                implant.imagePath!,):
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            SizedBox(height: context.height * 0.02),
                            Text(
                              controller.getImplantNameByKitId(implant.kitId ?? 0),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: context.height * 0.01),
                          ],
                        ),
                      ),

                      // Specifications section
                      buildSection(
                        context,
                        title: "Specifications",
                        children: [
                          BuildSpecItem(context, "Height", implant.height),
                          BuildSpecItem(context, "Width", implant.width),
                          BuildSpecItem(context, "Radius", implant.radius),
                        ],
                      ),

                      // Brand and Quantity section
                      buildSection(
                        context,
                        title: "Brand and Quantity",
                        children: [
                          BuildSpecItem(context, "Brand", implant.brand),
                          BuildSpecItem(context, "Quantity", '${implant.quantity}'),
                        ],
                      ),

                      // Description section
                      buildSection(
                        context,
                        title: "Description",
                        children: [
                          Text(
                            implant.description!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),

                      // Required Tools section
                      Obx(() {
                        final kitTools = kitId != null ? controller.getToolsByKitId(kitId) : [];
                        return buildSection(
                          context,
                          title: "Required Tools",
                          children: kitTools.isEmpty
                              ? [
                            Text(
                              'No tools required for this implant',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
                              ),
                            )
                          ]
                              : buildKitToolsList(kitTools, implantId),
                        );
                      }),

                      // Add to Cart button
                      SizedBox(height: context.height * 0.04),
                      Center(
                        child: CustomButton(
                          onTap: () {
                            final selectedTools = controller.selectedToolsForImplants[implantId]?.toList() ?? [];

                            if (selectedTools.isNotEmpty) {
                              controller.addPartialImplant(
                                implant,
                                tools: selectedTools,
                              );

                              Get.back();

                              Get.snackbar(
                                "Added",
                                "${controller.getImplantNameByKitId(implant.kitId ?? 0)} added to cart",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                icon: Icon(Icons.check_circle, color: Colors.white),
                                duration: Duration(seconds: 2),
                              );
                            } else {
                              Get.snackbar(
                                "Warning",
                                "Please select at least one tool",
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                icon: Icon(Icons.warning, color: Colors.white),
                                duration: Duration(seconds: 3),
                              );
                            }
                          },
                          text: 'Add to cart',
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: context.width * 0.5,
                    height: context.height * 0.16,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(context.width * 0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }


}
