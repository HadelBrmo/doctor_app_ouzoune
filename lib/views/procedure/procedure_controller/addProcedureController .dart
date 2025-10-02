import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/services/api_services.dart';
import 'package:ouzoun/models/doctor_model.dart';
import 'package:ouzoun/models/procedure_model.dart';
import '../../../Routes/app_routes.dart';
import '../../kits/Kits_Controller/kits_controller.dart';

class AddProcedureController extends GetxController {
  final KitsController kitsController = Get.put(KitsController());
  final ApiServices apiServices = Get.put(ApiServices());

  final patientNameController = TextEditingController();
  final needsAssistance = false.obs;
  final assistantsCount = 1.obs;
  final procedureType = 1.obs;
  final procedureDate = Rx<DateTime?>(null);
  final procedureTime = Rx<TimeOfDay?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetProcedureData();
  }

  void resetProcedureData() {
    try {
      print('🔄 Resetting add procedure data...');

      patientNameController.clear();
      needsAssistance.value = false;
      assistantsCount.value = 1;
      procedureType.value = 1;
      procedureDate.value = null;
      procedureTime.value = null;

      kitsController.selectedAdditionalTools.clear();
      kitsController.selectedImplants.clear();
      kitsController.selectedPartialImplants.clear();
      kitsController.selectedToolsForImplants.clear();
      kitsController.additionalToolQuantities.clear();

      print('Add procedure data reset successfully');
    } catch (e) {
      print(' Error resetting add procedure data: $e');
    }
  }

  // Select Date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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

  // Get Procedure Data
  Map<String, dynamic> getProcedureData() {
    final combinedDateTime = DateTime(
      procedureDate.value!.year,
      procedureDate.value!.month,
      procedureDate.value!.day,
      procedureTime.value!.hour,
      procedureTime.value!.minute,
    );

    return {
      "numberOfAssistants": assistantsCount.value,
      "date": combinedDateTime.toIso8601String(),
      "categoryId": procedureType.value,
      "toolsIds": getAdditionalToolsData(),
      "kitIds": getFullKitsData(),
      "implantTools": getPartialImplantsData(),
    };
  }

  List<Map<String, dynamic>> getAdditionalToolsData() {
    return kitsController.selectedAdditionalTools.map((tool) {
      final index = kitsController.additionalTools.indexOf(tool);
      final quantity = kitsController.additionalToolQuantities[index] ?? 1;

      return {
        "toolId": tool.id,
        "quantity": quantity,
      };
    }).toList();
  }

  List<int> getFullKitsData() {
    return kitsController.selectedImplants.values
        .map((implant) => implant.kitId)
        .where((kitId) => kitId != null)
        .cast<int>()
        .toList();
  }

  List<Map<String, dynamic>> getPartialImplantsData() {
    return kitsController.selectedPartialImplants.map((implant) {
      final implantId = implant.id.toString();
      final toolIds = kitsController.selectedToolsForImplants[implantId] ?? [];

      return {
        "implantId": implant.id,
        "toolIds": toolIds,
      };
    }).toList();
  }

  // Post Procedure
  Future<void> postProcedure() async {
    if (procedureDate.value == null || procedureTime.value == null) {
      Get.snackbar(
        'Error',
        'Procedure date and time are required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(15),
        titleText: Text(
          'Error',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        messageText: Text(
          'Procedure date and time are required'.tr,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
      return;
    }

    try {
      isLoading.value = true;
      final procedureData = getProcedureData();
      print('Sending procedure data: $procedureData');

      final box = GetStorage();
      final token = box.read('auth_token');

      final response = await apiServices.addProcedure(
        procedureData,
        token: token,
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Processing',
          'Your request is being processed...',
          titleText: Text(
            'Processing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Your request is being processed...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.grey,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );

        Get.snackbar(
          'Success',
          'Procedure added successfully'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          titleText: Text(
            'Success',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'Procedure added successfully'.tr,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );

        // Reset البيانات بعد الإضافة الناجحة
        resetProcedureData();

        // الانتقال إلى الشاشة المناسبة
        Get.offAllNamed(AppRoutes.homepage);
      } else {
        // معالجة الأخطاء
        String errorMsg = 'Failed to add procedure';
        if (response.data is Map<String, dynamic>) {
          errorMsg = response.data['message'] ??
              response.data['error'] ??
              errorMsg;
        } else if (response.data is String) {
          errorMsg = response.data;
        }

        Get.snackbar(
          'Error',
          errorMsg.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(15),
        );
      }
    } catch (e) {
      print('Error type: ${e.runtimeType}');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
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