import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/Widgets/custom_button.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import 'package:ouzoun/core/constants/app_images.dart';
import '../../../Widgets/custom_text_form_field.dart';
import '../../register/Widget/LocationPicker/locationPicker .dart';
import '../../register/register_controller.dart';
import '../myProfile_controller/editProfile_controller .dart';
import '../myProfile_controller/myProfile_controller.dart';
import '../widget/BuildEditableProfileItem .dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController controller = Get.put(EditProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        toolbarHeight: context.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text(
          "Edit My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Lottie.asset(
              AppAssets.LoadingAnimation,
              fit: BoxFit.cover,
              repeat: true,
              width: 200,
              height: 200,
            ),
          );
        }

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileImageSection(context),
                SizedBox(height: 30),
                _buildEditableFields(),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => CustomButton(
                        onTap: () {
                          if (!controller.isLoading.value) {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.updateProfile();
                            }
                          }
                        },
                        text: controller.isLoading.value ? "Saving..." : "Save Changes",
                        color: AppColors.primaryGreen,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: controller.pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: _buildProfileImage(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Tap to change photo',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (controller.selectedImage.value != null) {
      return ClipOval(
        child: Image.file(
          controller.selectedImage.value!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    } else if (controller.profileController.profileImagePath.value.isNotEmpty) {
      // عرض الصورة الحالية من الخادم
      return ClipOval(
        child: Image.network(
          controller.profileController.profileImagePath.value,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.person, size: 60, color: Colors.grey[400]);
          },
        ),
      );
    } else {
      return Icon(Icons.person, size: 60, color: Colors.grey[400]);
    }
  }

  Widget _buildEditableFields() {
    return Column(
      children: [
        BuildEditableProfileItem(
          icon: Icons.person,
          title: 'User Name',
          initialValue: '',
          onChanged: (value) => controller.userName.value = value,
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.email,
          title: 'Email Address',
          initialValue: '',
          onChanged: (value) => controller.email.value = value,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.phone,
          title: 'Phone Number',
          initialValue: '',
          onChanged: (value) => controller.phoneNumber.value = value,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            Get.dialog(
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                ),
              ),
              barrierDismissible: false,
            );

            try {
              await Get.to(() => LocationPicker(
                onLocationSelected: (coords, address) {

                  controller.updateLocation(coords, address);
                },
                useOSM: true,

              ));

            if (Get.isDialogOpen!) Get.back();
            } catch (e) {
              if (Get.isDialogOpen!) Get.back();
              Get.snackbar(
                'Error',
                'Failed to load map: ${e.toString()}',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: IgnorePointer(
            child: BuildEditableProfileItem(
              icon: Icons.location_on,
              title: 'Tap to choose Location',
              initialValue: '',
              onChanged: (value) {},
            ),
          ),
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.medical_services,
          title: 'Clinic Name',
          initialValue: '',
          onChanged: (value) => controller.clinicName.value = value,
        ),
        SizedBox(height: 20),
        BuildEditableProfileItem(
          icon: Icons.location_city,
          title: 'Clinic Address',
          initialValue: '', // دائماً فارغ
          onChanged: (value) => controller.clinicAddress.value = value,
        ),
      ],
    );
  }
}