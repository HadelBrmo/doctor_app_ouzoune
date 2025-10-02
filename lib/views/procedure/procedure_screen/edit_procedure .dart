import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/procedure_model.dart';
import '../procedure_controller/editProcedureController.dart';
import '../widget/buildProcedureEditHelper.dart';
import '../widget/buildProcedureHelper.dart' hide buildKitsToolsButtonsRow, buildDateTimeSelectionRow, buildProcedureTypeDropdown, buildAssistantsCountDropdown, buildNeedsAssistanceDropdown;
import '../widget/buildProcedureHelper.dart' as BuildProcedureHelper;

class EditProcedure extends StatefulWidget {
  final dynamic procedureData;

  EditProcedure({super.key, required this.procedureData});

  @override
  State<EditProcedure> createState() => _EditProcedureState();
}

class _EditProcedureState extends State<EditProcedure> {
  final EditProcedureController controller = Get.put(EditProcedureController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.procedureData is Procedure) {
        controller.loadProcedureData(widget.procedureData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          "Edit Procedure",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Get.width * 0.07),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildNeedsAssistanceDropdown(context),
            SizedBox(height: Get.height * 0.03),
            buildAssistantsCountDropdown(context),
            controller.needsAssistance.value?
            SizedBox(height: Get.height * 0.04):
            SizedBox(height: Get.height * 0.03),
            buildProcedureTypeDropdown(context),
            SizedBox(height: Get.height * 0.03),
            buildDateTimeSelectionRow(context),
            SizedBox(height: Get.height * 0.03),
            buildKitsToolsButtonsRow(context),
            SizedBox(height: Get.height * 0.05),
            buildUpdateButton( context),
          ],
        ),
      ),
    );
  }


}