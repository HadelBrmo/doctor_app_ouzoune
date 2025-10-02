import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/constants/app_colors.dart';
import '../procedure_controller/procedure_controller.dart';

void showFilterDialog(BuildContext context) {
  final ProcedureController controller = Get.find();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Filter Procedures",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TextField(
                cursorColor: AppColors.primaryBlue,
                decoration: InputDecoration(
                  hintText: 'Search by assistance name...',
                  hintStyle: TextStyle(fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(color: AppColors.primaryGreen),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) => controller.searchQuery.value = value,
              ),
              SizedBox(height: 14),
              TextField(
                cursorColor: AppColors.primaryGreen,
                decoration: InputDecoration(
                  hintText: 'Minimum assistants...',
                  hintStyle: TextStyle(fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(color: AppColors.primaryGreen),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.minAssistants.value = int.parse(value);
                  }
                },
              ),
              SizedBox(height: 14),
              TextField(
                cursorColor: AppColors.primaryGreen,
                decoration: InputDecoration(
                  hintText: 'Maximum assistants...',
                  hintStyle: TextStyle(fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(color: AppColors.primaryGreen),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.maxAssistants.value = int.parse(value);
                  }
                },
              ),
              SizedBox(height: 14),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  hintText: 'Select status',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(color: AppColors.primaryGreen),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Colors.black,
                ),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                value: controller.statusFilter.value > 0 ? controller.statusFilter.value : null,
                items: [
                  DropdownMenuItem(value: null, child: Text('All Statuses',
                    style:  TextStyle(fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  )),
                  DropdownMenuItem(value: 1, child: Text('Request_Sent',
                    style:  TextStyle(fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  )),
                  DropdownMenuItem(value: 2, child: Text('In_Progress',
                    style:  TextStyle(fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  )),
                  DropdownMenuItem(value: 3, child: Text('Done',
                    style:  TextStyle(fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  )),
                  DropdownMenuItem(value: 4, child: Text('Declined',
                    style:  TextStyle(fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  )),

                ],
                onChanged: (value) {
                  controller.statusFilter.value = value ?? 0;
                },
              ),
              SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    controller.fromDate.value?.toLocal().toString().split(' ')[0] ?? 'Select from date',
                    style: TextStyle(fontFamily: 'Montserrat',
                        fontSize: 14
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
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
                    if (selectedDate != null) {
                      controller.fromDate.value = selectedDate;
                    }
                  },
                ),
              ),
              SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(
                    controller.toDate.value?.toLocal().toString().split(' ')[0] ?? 'Select to date',
                    style: TextStyle(fontFamily: 'Montserrat',
                        fontSize: 14
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
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
                    if (selectedDate != null) {
                      controller.toDate.value = selectedDate;
                    }
                  },
                ),
              ),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.resetFilters();
              Get.back();
            },
            child: Text("Reset",
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontFamily:'Montserrat',
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel",
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontFamily:'Montserrat',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await controller.fetchAllProcedures();
                if (controller.proceduresList.isEmpty) {
                  Get.snackbar(
                    'Info',
                    'No procedures found with these filters',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                    margin: EdgeInsets.all(15),
                    titleText: Text(
                      'Info',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    messageText: Text(
                      'No procedures found with these filters',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                Get.back();
              } catch (e) {
                if (e.toString().contains('Data not Found')) {
                  Get.snackbar(
                    'Info',
                    'No matching procedures found',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                    margin: EdgeInsets.all(15),
                    titleText: Text(
                      'Info',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    messageText: Text(
                      'No matching procedures found',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                  controller.proceduresList.clear();
                  Get.back();
                } else {
                  Get.snackbar(
                    'Error',
                    'An error occurred',
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
                      'An error occurred',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Apply",
              style: TextStyle(
                color: Colors.white,
                fontFamily:'Montserrat',
              ),
            ),
          ),
        ],
      );
    },
  );
}