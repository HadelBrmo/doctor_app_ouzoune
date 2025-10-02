import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../Core/Services/media_query_service.dart';
import '../../core/constants/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back),
          color: Colors.white, onPressed: () { Get.back(); },
        ),
        toolbarHeight: context.height* 0.1, // 80 replaced
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(context.width * 0.06), // 22 replaced
          ),
        ),
        title: Text(
          "About app",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        backgroundColor: AppColors.primaryGreen,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: context.height * 0.025),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.4),
                borderRadius: BorderRadius.circular(context.width * 0.025),
              ),
              child: Column(
                children: [
                  Text(
                    "Welcome you in ouzoun app",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.whiteBackground
                          : AppColors.deepBlack,
                    ),
                  ),
                  SizedBox(height: context.height * 0.012),
                  Text(
                    "A platform for selling dental surgical tools",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.height * 0.03),

            _buildSection(
              context: context,
              icon: Icons.info,
              title: "Vision and mission",
              onTap: () {},
            ),

            _buildSection(
              context: context,
              icon: Icons.email,
              title: "Call us",
              onTap: () {},
            ),

            _buildSection(
              context: context,
              icon: Icons.privacy_tip,
              title: "Privacy policy",
              onTap: () {},
            ),

            Padding(
              padding: EdgeInsets.only(top: context.height * 0.05),
              child: Center(
                child: Text(
                  "© 2025 Ouzoun. All rights reserved",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {return Card(
      margin: EdgeInsets.only(bottom: 15),
      color: Theme.of(context).colorScheme.background,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGreen),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryGreen),
        onTap: onTap,
      ),
    );}
}