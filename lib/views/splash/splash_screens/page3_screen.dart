import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Core/Services/media_query_service.dart';
import '../../../Widgets/custom_text.dart';
import '../../../core/constants/app_images.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
  final media=MediaQueryHelper(context);

    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't worry".tr,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleLarge,),
                SizedBox(height: context.height * 0.02),
                Text("this App helps you, Let's start".tr,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium,),
                SizedBox(height: context.height * (context.isPortrait ? 0.065 : 0.04)),
               context.isPortrait
                ? Image.asset(
              AppAssets.onboarding3LightAndDarkBackground,
                 scale: media.width * 0.005,
              fit: BoxFit.cover,
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.onboarding3LightAndDarkBackground,
                  width: context.width * 0.5,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: context.width * 0.05),
              ],
            ),
          ]));
        },

      ),
    );
  }
}