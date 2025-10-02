import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';
import '../views/doctor_choices/Doctor_choices_controller/doctor_choices_controller.dart';


Future<int?> showQuantityDialog(String toolName) async {
  final TextEditingController controller = TextEditingController(text: '1');
  int quantity=1 ;

  return await Get.defaultDialog<int?>(
    title: 'Add amount',
    titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    content: Column(
      children: [
        Text('How many  $toolName  which you want'),
        SizedBox(height: 16),
        TextFormField(
          cursorColor: AppColors.primaryGreen,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "amount",
            hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontFamily: "Montserrat"
            ),
            //filled: true,
            //fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.green),),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.0),
            ),
          ),
          onChanged: (value) {
            quantity = int.tryParse(value) ?? 1;
          },
        ),
      ],
    ),
    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
      ),
      onPressed: () {
        Get.back(result: quantity);
      },
      child: Text('Ok', style: TextStyle(color: Colors.white)),
    ),
    cancel: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text('Cancel',
      style: TextStyle(
        color:Colors.red,
      ),
      ),
    ),
  ).then((value) => value ?? null);
}

