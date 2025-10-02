import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/services/api_services.dart';
import 'package:ouzoun/models/doctor_model.dart';
import 'package:ouzoun/models/procedure_model.dart';
import '../../../Routes/app_routes.dart';
import '../../../models/additionalTool_model.dart';
import '../../kits/Kits_Controller/kits_controller.dart';

class EditProcedureController extends GetxController {
  final KitsController kitsController = Get.put(KitsController());
  final ApiServices apiServices = Get.put(ApiServices());

  final patientNameController = TextEditingController();
  final needsAssistance = false.obs;
  final assistantsCount = 1.obs;
  final procedureType = 1.obs;
  final procedureDate = Rx<DateTime?>(null);
  final procedureTime = Rx<TimeOfDay?>(null);
  final RxBool isLoading = false.obs;
  final Rx<Procedure?> originalProcedure = Rx<Procedure?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  void loadProcedureData(Procedure procedure) {
    try {
      print('🔄 Loading procedure data for editing...');

      originalProcedure.value = procedure;

      patientNameController.text = procedure.doctor.userName ?? '';
      needsAssistance.value = procedure.numberOfAssistants > 0;
      assistantsCount.value = procedure.numberOfAssistants;
      procedureType.value = procedure.categoryId;
      procedureDate.value = procedure.date;
      procedureTime.value = TimeOfDay.fromDateTime(procedure.date);

      loadSelectedToolsAndImplants(procedure);

      print('Procedure data loaded successfully');
    } catch (e) {
      print(' Error loading procedure data: $e');
    }
  }

  void loadSelectedToolsAndImplants(Procedure procedure) {
    try {
      kitsController.selectedAdditionalTools.clear();
      kitsController.selectedImplants.clear();
      kitsController.selectedPartialImplants.clear();
      kitsController.selectedToolsForImplants.clear();
      kitsController.additionalToolQuantities.clear();

      for (var tool in procedure.tools) {
        final foundTool = kitsController.additionalTools.firstWhere(
              (t) => t.id == tool.id,

        );
        kitsController.selectedAdditionalTools.add(foundTool);

        final index = kitsController.additionalTools.indexOf(foundTool);
        if (index >= 0 && index < kitsController.additionalToolQuantities.length) {
          kitsController.additionalToolQuantities[index] = tool.quantity!;
        }
      }

      print(' Tools and implants loaded successfully');
    } catch (e) {
      print(' Error loading tools and implants: $e');
    }
  }

  // Select Date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: procedureDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800]!,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != procedureDate.value) {
      procedureDate.value = picked;
    }
  }

  // Select Time
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: procedureTime.value ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green[800]!,
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Colors.green[800]!,
              dialBackgroundColor: Colors.green[50]!,
              hourMinuteColor: Colors.green[100]!,
              hourMinuteTextColor: Colors.black,
              dayPeriodColor: Colors.green[100]!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != procedureTime.value) {
      procedureTime.value = picked;
    }
  }

  Map<String, dynamic> getProcedureDataForPatch() {
    final formattedDate = procedureDate.value != null && procedureTime.value != null
        ? DateTime(
      procedureDate.value!.year,
      procedureDate.value!.month,
      procedureDate.value!.day,
      procedureTime.value!.hour,
      procedureTime.value!.minute,
    ).toUtc().toIso8601String()
        : originalProcedure.value?.date.toUtc().toIso8601String();

    return {
      "id": originalProcedure.value?.id ?? 0,
      "date": formattedDate,
      "assistantIds": ["string"],
      "categoryId": procedureType.value,
      "status": originalProcedure.value?.status ?? 1,
      "toolIds": getToolIdsForPatch().isNotEmpty ? getToolIdsForPatch() : [0],
      "kitIds": getKitIdsForPatch().isNotEmpty ? getKitIdsForPatch() : [0],
    };
  }

  List<int?> getToolIdsForPatch() {
    return kitsController.selectedAdditionalTools.map((tool) => tool.id).toList();
  }

  List<int> getKitIdsForPatch() {
    return kitsController.selectedImplants.values
        .map((implant) => implant.kitId)
        .where((kitId) => kitId != null)
        .cast<int>()
        .toList();
  }

  Future<void> updateProcedure() async {
    if (procedureDate.value == null || procedureTime.value == null) {
      Get.snackbar(
        'Error',
        'Procedure date and time are required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final procedureData = getProcedureDataForPatch();
      print('Sending PATCH procedure data: $procedureData');

      final box = GetStorage();
      final token = box.read('auth_token');

      final response = await apiServices.updateProcedure(
        procedureData,
        token: token,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Procedure updated successfully'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back();
      } else {
        String errorMsg = 'Failed to update procedure';
        if (response.data is Map<String, dynamic>) {
          errorMsg = response.data['message'] ?? errorMsg;
        } else if (response.data is String) {
          errorMsg = response.data;
        }

        Get.snackbar(
          'Error',
          errorMsg.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating procedure: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    patientNameController.dispose();
    super.onClose();
  }
}