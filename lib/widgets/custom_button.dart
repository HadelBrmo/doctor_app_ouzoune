import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text, required this.color, Color,});
  final Function onTap;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      height:context.height * 0.07 ,
      child: InkWell(
        onTap: (){
          onTap!();
        },
        child:Center(
          child:Text(text,style:Theme.of(context).textTheme.headlineLarge,)
        ),
      ),
    );
  }
}
