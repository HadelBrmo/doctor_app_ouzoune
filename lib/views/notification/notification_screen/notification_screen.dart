import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ouzoun/core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../notification_controller/notification_controller.dart';
import '../widget/buildNotificationHelper.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,
          color: Colors.white,
        )),
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(MediaQuery.of(context).size.width * 0.06),
          ),
        ),
        title:  Text('Notifications',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () => controller.refreshNotifications(),
          ),

        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Lottie.asset(
                AppAssets.LoadingAnimation,
                fit: BoxFit.cover,
                repeat: true,
                width: 200,
                height: 200
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications found', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return Obx(() => Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryGreen,
                onRefresh: () => controller.refreshNotifications(),
                child: ListView.builder(
                  itemCount: controller.groupedNotifications.length,
                  itemBuilder: (context, groupIndex) {
                    final group = controller.groupedNotifications[groupIndex];
                    final date = group['date'] as String;
                    final groupNotifications = group['notifications'] as List;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            controller.formatDate(date),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: groupNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = groupNotifications[index];
                            return buildNotificationCard(notification, context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ));
      }),
      floatingActionButton: Obx(() => controller.notifications.isNotEmpty
          ? FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => showClearAllDialog(context, controller),
        child: const Icon(Icons.delete, color: Colors.white),
      )
          : const SizedBox.shrink()),
    );
  }


}