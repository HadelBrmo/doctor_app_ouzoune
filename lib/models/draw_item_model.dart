import 'package:flutter/cupertino.dart';

class DrawItemModel {
  final String text;
  final IconData icon;
  bool animated;
  final Function() function;

  DrawItemModel({
    required this.text,
    required this.icon,
    this.animated = false,
    required this.function,
  });
}
