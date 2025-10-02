import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../Core/Services/media_query_service.dart';

class CustomOtp extends StatelessWidget {
  CustomOtp({super.key,
    required this.onChanged,
    required this.onSubmit,
    required this.codeNumber,
    required this.focusedBorderColor,
    required this.cursorColor,
    required this.keyBoard});

  final Color cursorColor;
  final Color focusedBorderColor;
  final int codeNumber;
  final TextInputType keyBoard;
  final Function(String) onChanged;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: codeNumber,
      cursorColor: cursorColor,
      focusedBorderColor: focusedBorderColor,
      keyboardType: keyBoard,
      autoFocus: true,
      showFieldAsBox: true,
      onCodeChanged: onChanged,
      onSubmit: onSubmit,
    );
  }
}