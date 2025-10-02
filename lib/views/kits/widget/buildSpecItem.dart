import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget BuildSpecItem(BuildContext context, String title, dynamic value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
        Text(
          value.toString(), // تحويل أي نوع إلى String
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
      ],
    ),
  );
}
