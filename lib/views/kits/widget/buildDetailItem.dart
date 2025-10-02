import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget BuildDetailItem(BuildContext context, String title, dynamic value, {bool takeFirstDigit = false}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  dynamic displayValue = value.toString();

  if (takeFirstDigit && displayValue.isNotEmpty) {
    displayValue = displayValue[0];
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Montserrat",
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      Text(
        displayValue,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ],
  );
}