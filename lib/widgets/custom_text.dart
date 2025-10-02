import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
   final int max;
  final String fontFamily;
  final double fontSize;
  final bool isBold;
  final TextAlign textAlign;
  final Color color;
  final String text;
   CustomText({super.key,
     this.max=2,
    required this.fontFamily,
    required this.fontSize
    , required this.isBold,
    required this.color,
    required this.text,
     required this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    maxLines: max,
    style: TextStyle(
      fontSize:fontSize,
      fontFamily: fontFamily,
      fontWeight: isBold?FontWeight.bold:FontWeight.normal,
      color: color,
    ),
textAlign: textAlign,

    );
  }
}
