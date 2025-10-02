import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget BuildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
        SizedBox(width: 5),
        Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          value,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Montserrat'
          ),
        ),
      ],
    ),
  );
}