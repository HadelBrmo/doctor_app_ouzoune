import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';

Future<int?> ShowQuantityDialog(String toolName, {int maxQuantity = 999}) async {
  final quantityController = TextEditingController();
  int? selectedQuantity;
  final FocusNode _focusNode = FocusNode();
  final Color borderColor = AppColors.primaryGreen;
  final Color cursorColor = AppColors.primaryGreen;

  await Get.dialog(
    AlertDialog(
      title: Text("Select Quantity", style: TextStyle(fontFamily: 'Montserrat')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Available: $maxQuantity", style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.grey[600],
          )),
          SizedBox(height: 10),
          Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                _focusNode.requestFocus();
              }
            },
            child: Builder(
              builder: (context) {
                final isFocused = _focusNode.hasFocus;
                return TextField(
                  controller: quantityController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  cursorColor: cursorColor,
                  decoration: InputDecoration(
                    hintText: 'Enter quantity (1-$maxQuantity)',
                    hintStyle: TextStyle(fontFamily: 'Montserrat'),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isFocused ? borderColor : Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final entered = int.tryParse(value) ?? 0;
                      if (entered > maxQuantity) {
                        quantityController.text = maxQuantity.toString();
                        quantityController.selection = TextSelection.collapsed(
                          offset: quantityController.text.length,
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: null);
          },
          child: Text("Cancel", style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.primaryGreen,
          )),
        ),
        ElevatedButton(
          onPressed: () {
            if (quantityController.text.isNotEmpty) {
              final quantity = int.parse(quantityController.text);
              if (quantity > 0 && quantity <= maxQuantity) {
                selectedQuantity = quantity;
                Get.back(result: quantity);
              } else {
                Get.snackbar(
                  "Error",
                  "Please enter a valid quantity (1-$maxQuantity)",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            } else {
              Get.snackbar(
                "Error",
                "Please enter a quantity",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:AppColors.primaryGreen,
          ),
          child: Text("Confirm", style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
          )),
        ),
      ],
    ),
  );

  return selectedQuantity;
}