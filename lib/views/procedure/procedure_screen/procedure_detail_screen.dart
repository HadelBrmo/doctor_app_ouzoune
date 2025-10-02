// screens/procedure_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/views/procedure/procedure_controller/procedure_controller.dart';
import 'package:ouzoun/views/procedure/procedure_screen/edit_procedure%20.dart';
import '../../../models/ImplantKit .dart';
import '../../../models/Implant_model.dart';
import '../../../models/kit_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/procedure_model.dart';
import '../../kits/Kits_Controller/kits_controller.dart';
import '../widget/buildProcedureDetailsHelper.dart';

class ProcedureDetailScreen extends StatelessWidget {
  final int procedureId;
  final ProcedureController controller = Get.put(ProcedureController());

  ProcedureDetailScreen({super.key, required this.procedureId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedProcedure.value?.id != procedureId) {
        controller.fetchProcedureDetails(procedureId);
      }
    });

    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColors.deepBlack;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final procedure = controller.selectedProcedure.value;
      if (procedure == null) {
        return Center(child: Text('No procedure details found'));
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          toolbarHeight: context.height * 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(context.width * 0.06),
            ),
          ),
          title: Text("Procedure Details",
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white)),
          backgroundColor: AppColors.primaryGreen,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeaderCard(context, isDarkMode, textColor, procedure),
              SizedBox(height: 20),

              if (procedure.assistants.isNotEmpty) ...[
                buildSectionTitle(
                    'Assistants (${procedure.assistants.length})'),
                buildAssistantsList(procedure, isDarkMode),
                SizedBox(height: 20),
              ],

              if (procedure.tools.isNotEmpty) ...[
                buildSectionTitle('Required Tools (${procedure.tools.length})'),
                buildToolsList(procedure.tools, isDarkMode),
                SizedBox(height: 20),
              ],


              if (procedure.implantKits.isNotEmpty) ...[
                buildSectionTitle(
                    'Implant Kits (${procedure.implantKits.length})'),
                ...procedure.implantKits.map((implantKit) {
                  return buildImplantKitCard(implantKit, context, isDarkMode);
                }).toList(),
                SizedBox(height: 20),
              ],

              if (procedure.kits.isNotEmpty) ...[
                buildSectionTitle('Surgical Kits (${procedure.kits.length})'),
                ...procedure.kits.map((kit) {
                  if (kit.isMainKit) {
                    return buildSurgicalKitCard(kit, context, isDarkMode);
                  } else {
                    return buildKitCard(kit, context, isDarkMode);
                  }
                }).toList(),
                SizedBox(height: 20),
              ],

              if (procedure.assistants.isEmpty &&
                  procedure.tools.isEmpty &&
                  procedure.kits.isEmpty &&
                  procedure.implantKits.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text("No additional details available"),
                  ),
                ),
              SizedBox(height: 15,),
              // CustomButton(
              //     onTap: () {
              //       final procedure = controller.selectedProcedure.value;
              //       if (procedure != null) {
              //         Get.to(EditProcedure(procedureData: procedure));
              //       } else {
              //         Get.snackbar(
              //           'Error',
              //           'Please select a procedure first',
              //           backgroundColor: Colors.red,
              //           colorText: Colors.white,
              //         );
              //       }
              //     },
              //     text: "Update Procedure",
              //     color: AppColors.primaryGreen
              // )
            ],
          ),
        ),
      );
    });
  }
}

