import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Routes/app_routes.dart';
import 'package:ouzoun/views/doctor_choices/widget/showAssistantDialog.dart';

import '../../../Widgets/build_choice_card.dart';
import '../../../Widgets/custom_awesome_dialog.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/services/services.dart';
import '../Doctor_choices_controller/doctor_choices_controller.dart';

class SecondPageChoices extends StatelessWidget {
  SecondPageChoices({super.key});
  final AuthService authService = Get.put(AuthService());
  final DoctorChoicesController controller = Get.put(DoctorChoicesController());

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
        body: Stack(
          children: [
            Container(
              width: context.width,
              height: context.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: const DecorationImage(
                  opacity: 0.8,
                  image: AssetImage(AppAssets.femaleDentistIcon),
                  fit: BoxFit.fitWidth,
                ),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                children: [
                  SizedBox(height: context.height * 0.1),
                  Text(
                    "please choose.\n How many assistants do you usually need?",
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  SizedBox(height: context.height * 0.4),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Obx(() =>
                                BuildChoiceCard(
                                  color: AppColors.primaryGreen,
                                  height: context.isPortrait
                                      ? context.height * 0.20
                                      : context.height * 0.4,
                                  icon: FontAwesomeIcons.handsHelping,
                                  onTap: () {
                                    showAssistantsDialog(context);
                                  },
                                  subtitle: controller.selectedAssistants.value > 0
                                      ? '${controller.selectedAssistants.value} assistant(s)'
                                      : '',
                                  textColor: AppColors.whiteBackground,
                                  title: 'With an assistant',
                                )),
                          ),
                          SizedBox(width: context.width * 0.05),
                          Flexible(
                            child: BuildChoiceCard(
                              color: AppColors.primaryGreen,
                              height: context.isPortrait
                                  ? context.height * 0.20
                                  : context.height * 0.4,
                              icon: FontAwesomeIcons.userSlash,
                              onTap: () {
                                controller.selectedAssistants.value = 0;
                                controller.showNextButton.value = true;
                                controller.withoutAssistantClicked.value = true;
                              },
                              subtitle: controller.withoutAssistantClicked.value
                                  ? '${controller.selectedAssistants
                                  .value} assistant(s)'
                                  : '',
                              textColor: AppColors.whiteBackground,
                              title: 'without an assistant',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() =>
            controller.showNextButton.value &&
                controller.selectedAssistants.value >= 0
                ? Positioned(
              bottom: context.height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (authService.isLoggedIn.value) {
                      Get.offAllNamed(AppRoutes.homepage);
                    } else {
                      Get.toNamed(AppRoutes.login);
                    }
                  },
                  child: Text(
                    "next".tr,
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      );
    });
  }
}