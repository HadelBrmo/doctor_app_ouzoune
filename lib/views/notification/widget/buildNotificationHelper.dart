import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/constants/app_colors.dart';
import '../notification_controller/notification_controller.dart';

Widget buildNotificationCard(Map<String, dynamic> notification, BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final isRead = notification['read'] ?? false;

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
        width: 1.5,
      ),
    ),
    elevation: 0,
    color: isDarkMode ? Colors.grey[900] : Colors.white,
    margin: const EdgeInsets.all(12),
    child: ListTile(
      leading: Icon(
        isRead ? Icons.notifications_none : Icons.notifications_active,
        color: isRead ? Colors.grey : AppColors.primaryGreen,
        size: 35,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            notification['title'],
            style: TextStyle(
              fontSize: 17.5,
              fontFamily: 'Montserrat',
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              color: isRead ? Colors.grey[600] : null,
            ),
          ),
          Text(
            formatTime(notification['createdAt']),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
      subtitle: Text(
            notification['body'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: isRead ? Colors.grey[500] : Colors.grey,
            ),
          ),


      ),
    );

}

String formatTime(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return dateString;
  }
}

void showClearAllDialog(BuildContext context, NotificationController controller) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Delete all',
        style: TextStyle(fontFamily: 'Montserrat'),
      ),
      content: const Text(
        'Do you want to delete all notifications?',
        style: TextStyle(fontFamily: 'Montserrat'),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            controller.clearAllNotifications();
            Get.back();
            Get.snackbar('Done', 'All notifications deleted');
          },
          child: const Text(
            'Confirm',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    ),
  );
}