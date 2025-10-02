import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ouzoun/views/setting/setting_controller/setting_controller.dart';
import 'package:ouzoun/views/setting/setting_screen/widget/settingHelper.dart';
import '../../../Core/Services/media_query_service.dart';
import '../../../Routes/app_routes.dart';
import '../../../Widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/services.dart';
import '../../login/login_screen.dart';
import '../../myProfile/myProfile_controller/myProfile_controller.dart';
import 'changePassword.dart';

class SettingsScreen extends StatelessWidget {
   SettingsScreen({super.key});
   SettingController controller = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),
        color: Colors.white, onPressed: () { Get.back(); },
        ),
        toolbarHeight: context.height* 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06),
          ),
        ),
        title: Text(
          "Setting",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.width * 0.04),
        child: Column(
          children: [
            buildAccountCard(context),
            buildSettingsSection(context, title: "public", icon: Icons.settings,
              children: [
                buildSettingItem(
                  context,
                  icon: Icons.language,
                  title: "Languages",
                  value: "English",
                  onTap: () => changeLanguage(context),
                ),
                buildSettingItem(
                  context,
                  icon: Icons.color_lens,
                  title: "Appearance",
                  trailing: Obx(() => Switch(
                    value: controller.isDarkMode.value,
                    onChanged: (value) => changeTheme(context),
                    activeColor: AppColors.primaryGreen,
                  )),
                ),
              ],
            ),
            buildSettingsSection(context, title: "Security", icon: Icons.security,
              children: [
                buildSettingItem(
                  context,
                  icon: Icons.lock,
                  title: "change password".tr,
                  onTap: () => Get.to(() => ChangePasswordPage()),
                ),
                buildSettingItem(
                  context,
                  icon: Icons.email,
                  title: "change email",

                ),
              ],
            ),
            buildSettingsSection(context, title: "Support", icon: Icons.support_agent,
              children: [
                buildSettingItem(
                  context,
                  icon: Icons.help,
                  title: "Help",
                  onTap: () => {},
                ),
                buildSettingItem(
                  context,
                  icon: Icons.phone,
                  title: "Call us ",
                  onTap: () => {},
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: context.height * 0.03),
              child: SizedBox(
                width: double.infinity,
                child:   CustomButton(
                  onTap: (){
                    logout(context);
                  },
                  text: 'Log out'.tr, color: AppColors.primaryGreen,

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: context.height * 0.03),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onTap: deleteAccount,
                  text: 'Delete account'.tr,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  }
