// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     final InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         debugPrint('Notification tapped: ${response.id}');
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//
//     await requestAndroidNotificationPermission();
//   }
//
//   Future<void> scheduleBedtimeNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'bedtime_channel_id',
//       'Bedtime Notifications',
//       channelDescription: 'Channel for bedtime reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
//
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzScheduledDate,
//       notificationDetails,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
//
//   Future<void> requestAndroidNotificationPermission() async {
//     if (await Permission.notification.isGranted) {
//       debugPrint('Notification permission already granted!');
//     } else {
//       final status = await Permission.notification.request();
//       debugPrint('Notification permission status: $status');
//     }
//   }
// }
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse notificationResponse) {
//   debugPrint(
//       'Notification (ID: ${notificationResponse.id}) tapped while in background. Action ID: ${notificationResponse.actionId}');
// }