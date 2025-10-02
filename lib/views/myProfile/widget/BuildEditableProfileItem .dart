// buildEditableProfileItem.dart
import 'package:flutter/material.dart';
import 'package:ouzoun/core/constants/app_colors.dart';

class BuildEditableProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  const BuildEditableProfileItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.initialValue,
     this.onChanged,
    this.onTap,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TextFormField(
        cursorColor: AppColors.primaryGreen,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.grey
          ),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}