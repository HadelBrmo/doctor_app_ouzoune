import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../myProfile_controller/myProfile_controller.dart';
import '../widget/buildProfileItem.dart';
import 'EditProfileScreen .dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({super.key});
  final controller = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Obx(() => Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: context.height * 0.20,
            child: Container(
              color: AppColors.primaryGreen,
              child: Center(
                child: Text(
                  'My Personal Profile',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: context.height * 0.85,
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.deepBlack : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: context.height * 0.05),
                      width: context.width * 0.35,
                      height: context.width * 0.35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: buildProfileImage(),
                    ),
                    SizedBox(height: context.height * 0.03),
                    if (controller.isLoading.value)
                      Center(
                        child: Padding(
                          padding:  EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                        child: Column(
                          children: [
                            buildProfileItem(
                              context,
                              icon: Icons.person,
                              title: 'Name',
                              value: controller.userName.value,
                            ),
                            SizedBox(height: 10),
                            buildProfileItem(
                              context,
                              icon: Icons.email,
                              title: 'Email',
                              value: controller.email.value,
                            ),
                            SizedBox(height: 10),
                            buildProfileItem(
                              context,
                              icon: Icons.phone,
                              title: 'Phone',
                              value: controller.phoneNumber.value,
                            ),
                            SizedBox(height: 10),
                            buildProfileItem(
                              context,
                              icon: Icons.location_pin,
                              title: 'Location',
                              value: controller.isConvertingAddress.value
                                  ? 'Loading address...'
                                  : controller.location.value,
                            ),
                            SizedBox(height: 10),
                            buildProfileItem(
                              context,
                              icon: Icons.medical_services_rounded,
                              title: 'Clinic Name',
                              value: controller.clinicName.value,
                            ),
                            SizedBox(height: 10),
                            buildProfileItem(
                              context,
                              icon: Icons.business_sharp,
                              title: 'Clinic Address',
                              value: controller.clinicAddress.value,
                            ),
                            SizedBox(height: context.height * 0.03),
                            CustomButton(
                              onTap:  (){
                                Get.to(EditProfileScreen());
                              },
                              text: "Update my profile",
                              color: AppColors.primaryGreen,
                            ),
                            SizedBox(height: context.height * 0.05),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        ],
      )),
    );
  }


}