
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../myProfile_controller/myProfile_controller.dart';

Widget buildProfileImage() {
  final controller = Get.put(MyProfileController());
  final imagePath = controller.profileImagePath.value;

  if (imagePath.isEmpty) {
    return Icon(Icons.person, color: Colors.grey[500], size: 80);
  }

  return ClipOval(
    child: Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.person, color: Colors.grey[500], size: 80);
      },
    ),
  );
}

Widget buildProfileItem(BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: context.height * 0.02),
    padding: EdgeInsets.all(context.width * 0.04),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: context.width * 0.06,
        ),
        SizedBox(width: context.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: context.height * 0.005),
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}