import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/core/constants/app_images.dart';
import 'package:ouzoun/widgets/custom_button.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../Widgets/custom_text.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/additionalTool_model.dart';
import '../Kits_Controller/kits_controller.dart';
import '../widget/buildToolCard.dart';
import '../widget/buildDetailItem.dart';
import '../widget/showAdditionalToolsDialog.dart';
import '../widget/showQuantityDialog.dart';

class AdditionalKits extends StatelessWidget {
  final KitsController controller = Get.put(KitsController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AdditionalKits({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () => showSelectedToolsDialog(controller.selectedAdditionalTools),
              icon: Obx(() => Badge(
                label: Text('${controller.selectedAdditionalTools.length}'),
                child: const Icon(Icons.shopping_cart_checkout_outlined, color: Colors.white),
              )),
            ),
          )],
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("Additional tools", style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.additionalTools.isEmpty) {
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

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.02,
          ),
          child: Column(
            children: [
               Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.width * 0.04),
              margin: EdgeInsets.only(bottom: context.height * 0.02),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello Doctor,",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: context.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: context.height * 0.01),
                  Text(
                    "This page is dedicated to additional tools that may assist you in the surgical procedure you are performing. Simply select the quantity you need.",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: context.width * 0.035,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: context.height * 0.01),
                  Row(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Note : ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: "Montserrat",
                          fontSize: context.width * 0.035,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Do not exceed the available quantity...",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: "Montserrat",
                            fontSize: context.width * 0.035,
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  )

                ],)
          ),
              Expanded(
                child: buildToolsList(context),
              ),
              buildSaveButton(context),
            ],
          ),
        );
      }),
    );
  }


  Widget buildToolsList(BuildContext context) {
    return Obx(() => AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: controller.additionalTools.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: BuildToolCard(
                  tool: controller.additionalTools[index],
                  selectedQuantity: controller.additionalToolQuantities[index],
                  onQuantitySelected: (quantity) {
                    controller.updateAdditionalToolQuantity(index, quantity);
                  },
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomButton(
        onTap: () {
          final selectedIds = controller.getSelectedToolsIds();
          Get.back(result: selectedIds);
        },
        text: "Save Selection",
        color: AppColors.primaryGreen,
      ),
    );
  }
}