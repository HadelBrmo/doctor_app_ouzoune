import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../core/services/LocalNotificationService .dart';
import '../../../core/services/api_services.dart';

class NotificationController extends GetxController {
  final notifications = <Map<String, dynamic>>[].obs;
  final groupedNotifications = <Map<String, dynamic>>[].obs;
  final hasUnreadNotifications = false.obs;
  final unreadCount = 0.obs;
  final ApiServices apiServices = Get.put(ApiServices());
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
   // _setupNotificationListener();
  }

  // void _setupNotificationListener() {
  //   ever(LocalNotificationService.instance.hasNewNotification, (hasNew) {
  //     if (hasNew != null) {
  //       refreshNotifications();
  //       LocalNotificationService.instance.hasNewNotification.value = false;
  //     }
  //   });
  //
  //   LocalNotificationService.instance.streamController.stream.listen((response) {
  //     refreshNotifications();
  //   });
  // }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final response = await apiServices.getCurrentUserNotifications();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print('Notifications response: $responseData');

        notifications.clear();
        groupedNotifications.clear();

        if (responseData is List) {
          final sortedGroups = List.from(responseData);
          sortedGroups.sort((a, b) {
            final dateA = DateTime.parse(a['createdAt'] ?? '');
            final dateB = DateTime.parse(b['createdAt'] ?? '');
            return dateB.compareTo(dateA);
          });

          for (var group in sortedGroups) {
            if (group is Map<String, dynamic>) {
              final notificationsList = group['notifications'] as List? ?? [];

              notificationsList.sort((a, b) {
                final dateA = DateTime.parse(a['createdAt'] ?? '');
                final dateB = DateTime.parse(b['createdAt'] ?? '');
                return dateB.compareTo(dateA);
              });

              for (var notification in notificationsList) {
                notifications.add({
                  'id': notification['id'] ?? 0,
                  'title': notification['title'] ?? 'No title',
                  'body': notification['body'] ?? 'No message',
                  'read': notification['read'] ?? false,
                  'createdAt': notification['createdAt'] ?? DateTime.now().toString(),
                  'groupDate': group['createdAt']?.toString() ?? '',
                });
              }

              groupedNotifications.add({
                'date': group['createdAt']?.toString() ?? '',
                'notifications': notificationsList,
              });
            }
          }

          checkUnreadNotifications();
        }
      }
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    print('Refreshing notifications...');
    await loadNotifications();
    update();
  }

  void sortNotificationsDescending() {
    notifications.sort((a, b) {
      final dateA = DateTime.parse(a['createdAt'] ?? '');
      final dateB = DateTime.parse(b['createdAt'] ?? '');
      return dateB.compareTo(dateA);
    });

    groupedNotifications.sort((a, b) {
      final dateA = DateTime.parse(a['date'] ?? '');
      final dateB = DateTime.parse(b['date'] ?? '');
      return dateB.compareTo(dateA);
    });

    for (var group in groupedNotifications) {
      final notificationsList = group['notifications'] as List;
      notificationsList.sort((a, b) {
        final dateA = DateTime.parse(a['createdAt'] ?? '');
        final dateB = DateTime.parse(b['createdAt'] ?? '');
        return dateB.compareTo(dateA);
      });
    }

    notifications.refresh();
    groupedNotifications.refresh();
  }

  void checkUnreadNotifications() {
    final unread = notifications.where((n) => n['read'] == false).toList();
    hasUnreadNotifications.value = unread.isNotEmpty;
    unreadCount.value = unread.length;
  }





  void clearAllNotifications() {
    notifications.clear();
    groupedNotifications.clear();
    hasUnreadNotifications.value = false;
    unreadCount.value = 0;
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEEE, MMMM d, y').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}