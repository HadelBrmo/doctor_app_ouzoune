import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../core/constants/app_images.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.05,
            vertical: context.height * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "And".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: context.isPortrait ? 24 : 20,
                ),
              ),

              SizedBox(height: context.height * (context.isPortrait ? 0.03 : 0.02)),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * (context.isPortrait ? 0.05 : 0.1),
                ),
                child: Text(
                  "you Find difficult to choose the assistant and tools".tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: context.isPortrait ? 18 : 16,
                  ),
                ),
              ),

              SizedBox(height: context.height * (context.isPortrait ? 0.07 : 0.05)),
              context.isPortrait
                  ? Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? AppAssets.onboarding2DarkBackground
                    : AppAssets.onboarding2LightBackground,
                width: context.width * 0.9,
                fit: BoxFit.contain,
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? AppAssets.onboarding2DarkBackground
                        : AppAssets.onboarding2LightBackground,
                    width: context.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: context.width * 0.05),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}