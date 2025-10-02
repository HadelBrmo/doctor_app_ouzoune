import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/views/procedure/procedure_screen/add_procedure.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Widgets/custom_drawer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../Kits_Controller/kits_controller.dart';
import '../widget/buildDetailRow.dart';
import '../widget/buildImplantCard.dart';
import '../widget/showImplantDialog.dart';

class Implantkits extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final KitsController controller = Get.put(KitsController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: scaffoldKey,
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () => {
                 showImplantsDialog(context),
              },
              icon: Obx(() => Badge(
                label: Text('${controller.selectedImplants.length}'),
                child: Icon(Icons.shopping_cart_checkout_outlined, color: Colors.white),
              )),
            ),
          )],
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("Implant Kits", style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Obx(() {
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
        if (controller.implants.isEmpty) {
          return Center(child: Text('No implants available',
          style: TextStyle(
            fontFamily: "Montserrat",
          ),
          ));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(context.width * 0.04),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.width * 0.04),
                margin: EdgeInsets.only(bottom: context.height * 0.02),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
                    width: 1,
                  ),
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
                      "This page allows you to select the appropriate implant and the tools needed for each procedure. "
                          "You can view the specific tools required for each implant by clicking 'View details'.",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: context.width * 0.035,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: context.height * 0.01),
                    Text(
                      "Note: The required tools for each implant can be found in the details section.",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: context.width * 0.035,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              ...controller.implants.map((implant) => BuildImplantCard(context, implant)),
            ],
          ),
        );
      }),
    );
  }
}