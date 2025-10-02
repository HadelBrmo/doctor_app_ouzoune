import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/build_choice_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/services/services.dart';

class FirstPageChoices extends StatelessWidget {
   FirstPageChoices({super.key});
  final AuthService authService = Get.put(AuthService());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authService.isLoggedIn.value) {
        Future.delayed(
            Duration.zero, () => Get.offAllNamed(AppRoutes.homepage));
        return Scaffold(body: Center(child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        )));
      }

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          width: context.width,
          height: context.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              opacity: 0.8,
              scale: 0.40,
              image: const AssetImage(AppAssets.maleDentistIcon),
              fit: BoxFit.fitWidth,
            ),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            children: [
              SizedBox(height: context.height * 0.1),
              Text(
                "Welcome to your app.\n What do you usually need? ",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: context.height * 0.4),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.05,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BuildChoiceCard(
                        color: AppColors.primaryGreen,
                        height: context.isPortrait
                            ? context.height * 0.20
                            : context.height * 0.4,
                        icon: FontAwesomeIcons.userDoctor,
                        onTap: () {
                          if (authService.isLoggedIn.value) {
                            Get.offAllNamed(AppRoutes.homepage);
                          } else {
                            Get.toNamed(AppRoutes.secondchoice);
                          }
                        },
                        subtitle: '',
                        textColor: AppColors.whiteBackground,
                        title: 'Surgical operation',
                      ),
                      SizedBox(width: context.width * 0.05),
                      BuildChoiceCard(
                        color: AppColors.primaryGreen,
                        height: context.isPortrait
                            ? context.height * 0.20
                            : context.height * 0.4,
                        icon: Icons.inventory_2,
                          onTap: () {
                            if (authService.isLoggedIn.value) {
                              Get.offAllNamed(AppRoutes.homepage);
                            } else {
                              Get.toNamed(AppRoutes.secondchoice);
                            }
                          },
                        subtitle: '',
                        textColor: AppColors.whiteBackground,
                        title: 'Medical supplies.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}