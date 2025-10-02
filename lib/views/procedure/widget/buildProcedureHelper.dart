import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/Implant_model.dart';
import '../../kits/Kits_Controller/kits_controller.dart';
import '../../kits/kits_screens/detail_kit.dart';
import '../../kits/kits_screens/implant_kits.dart';
import '../procedure_controller/addProcedureController .dart';
import '../procedure_controller/procedure_controller.dart';
import '../procedure_screen/get_all_procedures.dart';


Widget buildNeedsAssistanceDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(AddProcedureController());
  return Obx(() => DropdownButtonFormField<bool>(
    items: [
      DropdownMenuItem(
        value: true,
        child: Text('Yes', style: Theme.of(context).textTheme.headlineSmall),
      ),
      DropdownMenuItem(
        value: false,
        child: Text('No', style: Theme.of(context).textTheme.headlineSmall),
      ),
    ],
    onChanged: (value) => controller.needsAssistance.value = value!,
    value: controller.needsAssistance.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Needed Assistance',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),));
}

Widget buildAssistantsCountDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(AddProcedureController());
  return Obx(() => controller.needsAssistance.value
      ? DropdownButtonFormField<int>(
    items: List.generate(5, (index) => index + 1)
        .map((count) => DropdownMenuItem(
      value: count,
      child: Text(count.toString(),
          style: Theme.of(context).textTheme.headlineSmall),
    ))
        .toList(),
    onChanged: (value) => controller.assistantsCount.value = value!,
    value: controller.assistantsCount.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Number of Assistance',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),
  )
      : const SizedBox.shrink());
}

Widget buildProcedureTypeDropdown(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final borderColor = isDark ? Colors.white : Colors.grey;
  final controller = Get.put(ProcedureController());
  return Obx(() => DropdownButtonFormField<int>(
    items: [
      DropdownMenuItem(
        value: 1,
        child: Text(
          'Medical Supplies',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text(
          'Surgical Operation',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    ],
    onChanged: (value) => controller.procedureType.value = value!,
    value: controller.procedureType.value,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      labelText: 'Procedure Type',
      labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: isDark ? Colors.white70 : Colors.black54,
      ),
    ),
  ));
}

Widget buildDateTimeSelectionRow(BuildContext context) {
  final controller = Get.put(AddProcedureController());
  return Row(
    children: [
      Expanded(
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => controller.selectDate(context),
          child: Text(
            controller.procedureDate.value == null
                ? 'Select Date'
                : ' ${controller.procedureDate.value?.toLocal().toString().split(' ')[0]}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
        )),
      ),
      SizedBox(width: Get.width * 0.03),
      Expanded(
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => controller.selectTime(context),
          child: Text(
            controller.procedureTime.value == null
                ? 'Select Time'
                : 'Time : ${controller.procedureTime.value?.format(context)}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
        )),
      ),
    ],
  );
}

Widget buildKitsToolsButtonsRow(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final controller = Get.find<KitsController>();

  return Column(
    children: [
      // Partial Implants
      Obx(() => Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: controller.selectedPartialImplants.isEmpty
            ? Center(
          child: TextButton(
            onPressed: () async {
              controller.clearSelectedImplants();

              final result = await Get.to(() => Implantkits());
              print('Result from Implantkits: $result');

              if (result != null && result is Implant) {
                print('Implant selected for partial: ${result.id} - ${result.brand}');

                final toolsResult = await Get.to(() => ImplantDetailScreen(implant: result));

                if (toolsResult != null && toolsResult is Map) {
                  controller.addPartialImplant(
                    result,
                    tools: toolsResult['selectedTools']?.cast<int>() ?? [],
                  );
                }
              }
            },
            child: Text('Tap to choose Partial Implants / Tools',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.grey,
                )),
          ),
        )
            : buildPartialImplantsList(context),
      )),
      SizedBox(height: 20),
      //full  Implants
      Obx(() => Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: controller.selectedImplants.isEmpty
            ? TextButton(
          onPressed: () async {
            await Get.to(() => Implantkits());
          },
          child: Text('Tap to choose Full Implant Kits',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.grey,
              )),
        )
            : buildSelectedImplantsList(context),
      )),
      SizedBox(height: 20),
      // Additional Tools
      Obx(() => Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: controller.selectedAdditionalTools.isEmpty
            ? ElevatedButton(
          onPressed: () async {
            await Get.toNamed(AppRoutes.additional_kit);
            controller.updateSelectedTools();
          },
          child: Text('Tap to choose Additional Tools',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontFamily: 'Montserrat',
              )),
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isDarkMode ? Theme.of(context).cardColor : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
            : Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.selectedAdditionalTools.length,
                  itemBuilder: (context, index) {
                    final tool = controller.selectedAdditionalTools[index];
                    final quantity = controller.additionalToolQuantities[
                    controller.additionalTools.indexOf(tool)];
                    return ListTile(
                      title: Text(tool.name ?? 'Unknown Tool',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          )),
                      trailing: Text('x $quantity',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          )),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () async {
                    await Get.toNamed(AppRoutes.additional_kit);
                    controller.updateSelectedTools();
                  },
                  child: Text(
                    'Edit Selection',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),


    ],
  );
}

Widget buildSubmitButton(BuildContext context) {
  final controller = Get.put(AddProcedureController());
  return CustomButton(
    onTap: () async {

      await controller.postProcedure();

    },
    text: 'Confirm Procedure',
    color: AppColors.primaryGreen,

  );
}

Widget buildSelectedImplantsList(BuildContext context) {
  final controller = Get.find<KitsController>();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Selected Full Implant Kits:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              fontFamily: 'Montserrat',
            )),
        SizedBox(height: 10),
        ...controller.selectedImplants.entries.map((entry) => Card(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
                controller.getImplantNameByKitId(entry.value.kitId ?? 0),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  controller.toggleImplantSelection(entry.key, entry.value),
            ),
          ),
        )).toList(),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            await Get.to(() => Implantkits());
          },
          child: Text(
            'Edit Selection',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildPartialImplantsList(BuildContext context) {
  final controller = Get.find<KitsController>();

  return Obx(() {

    print('Partial Implants Count: ${controller.selectedPartialImplants.length}');
    controller.selectedPartialImplants.forEach((implant) {
      print('Implant: ${implant.id}, name: ${controller.getImplantNameByKitId(implant.kitId ?? 0)}');
      print('Associated Tools: ${controller.selectedToolsForImplants[implant.id.toString()]?.join(', ') ?? 'None'}');
    });
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Selected Partial Implants with Tools',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          if (controller.selectedPartialImplants.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No partial implants selected. Tap "Add Another" to select.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: controller.selectedPartialImplants.length,
                itemBuilder: (context, index) {
                  final implant = controller.selectedPartialImplants[index];
                  final toolIds = controller.selectedToolsForImplants[implant.id.toString()] ?? [];

                  final toolNames = toolIds.map((toolId) {
                    final tool = controller.additionalTools.firstWhereOrNull(
                            (t) => t.id == toolId
                    );
                    return tool?.name ?? 'Tool ID: $toolId';
                  }).toList();

                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        controller.getImplantNameByKitId(implant.kitId ?? 0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (toolNames.isNotEmpty)
                            Text(
                              'Tools: ${toolNames.join(', ')}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'Montserrat',
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removePartialImplant(implant.id.toString()),
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              onPressed: () async {
                final result = await Get.to(() => Implantkits());
                if (result != null && result is Implant) {
                  final toolsResult = await Get.to(
                          () => ImplantDetailScreen(implant: result)
                  );
                  if (toolsResult != null && toolsResult is Map) {
                    controller.addPartialImplant(
                      result,
                      tools: toolsResult['selectedTools']?.cast<int>() ?? [],
                    );
                    Get.snackbar(
                      'Success',
                      'Implant added successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              child: Text(
                'Add Another',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}