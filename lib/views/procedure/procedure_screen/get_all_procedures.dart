// views/procedures_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../models/Implant_model.dart';
import '../../../models/assistant_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/procedure_controller.dart';
import '../widget/buildProceduresList.dart';
import '../widget/showFilterDialog.dart';
import '../widget/showPaginationDialog.dart';


class ProceduresScreen extends StatelessWidget {
  final ProcedureController controller = Get.put(ProcedureController(),

  );
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
        showFilterDialog(context),

            icon: Icon(Icons.tune, color: Colors.white),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text("All Procedures",
            style: Theme.of(context).textTheme.titleSmall),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Obx((){
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
                Text('No procedures found',
                style: TextStyle(
                  fontFamily: "Montserrat",
                ),
                ),
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
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.width * 0.04),
                margin: EdgeInsets.only(bottom: context.height * 0.01),
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
                      "On this page you can see all your procedures with date and their assistants...",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: context.width * 0.035,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: buildProceduresList()),
              Obx(() => TextButton(
                onPressed: (){
                  showPaginationDialog(context,);
                },
                child: Text(
                  'page  ${controller.currentPage} - show ${controller.itemsPerPage} element',
                  style: TextStyle(
                      fontFamily:'Montserrat',
                    color: Colors.white
                  ),
                ),
              ),
              ),
            ],
          ),
        );
          } ),
    );
  }

}