import 'package:flutter/material.dart';
import '../Services/media_query_service.dart';
import 'app_colors.dart';
ThemeData lightMode=ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(color:AppColors.primaryGreen),
  colorScheme: ColorScheme.light(background:AppColors.whiteBackground),
  primaryColor:AppColors.primaryGreen,
  buttonTheme:ButtonThemeData(buttonColor:AppColors.primaryGreen),
  textTheme: TextTheme(
    bodySmall: TextStyle(fontFamily:'Ubuntu',fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.primaryGreen ),
   headlineLarge:TextStyle(fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.bold, color:AppColors.whiteBackground,),
    headlineMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 15, color:AppColors.whiteBackground),
   headlineSmall:TextStyle(fontFamily: 'Montserrat', fontSize: 15, color:AppColors.deepBlack,fontWeight:FontWeight.bold),
   titleLarge:TextStyle(color:AppColors.deepBlack,fontFamily:'Ubuntu',fontWeight:FontWeight.bold,fontSize:25),
   titleMedium: TextStyle(fontFamily:'Montserrat',color:Colors.grey,fontSize:15),
    titleSmall: TextStyle(fontFamily:'Montserrat',color:Colors.white,fontSize:20,fontWeight:FontWeight.bold,),
  ),);
ThemeData darkMode=ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(color:AppColors.primaryGreen),
  colorScheme: ColorScheme.dark(background:AppColors.deepBlack),
  textTheme: TextTheme(
    bodySmall: TextStyle(fontFamily:'Ubuntu',fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.primaryGreen ),
    headlineLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.bold, color:AppColors.whiteBackground,),
    headlineMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 15, color:AppColors.lightGreen),
    headlineSmall:TextStyle(fontFamily: 'Montserrat', fontSize: 15, color:AppColors.whiteBackground,fontWeight:FontWeight.bold),
    titleLarge:TextStyle(color:AppColors.whiteBackground,fontFamily:'Ubuntu',fontWeight:FontWeight.bold,fontSize:25),
    titleMedium:TextStyle(fontFamily:'Montserrat',color:AppColors.lightGreen,fontSize:15),
    titleSmall: TextStyle(fontFamily:'Montserrat',color:Colors.white,fontSize:20,fontWeight:FontWeight.bold,),

  ),

  );
