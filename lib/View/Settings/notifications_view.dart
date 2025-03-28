// import 'package:flutter/material.dart';
// import '../../Services/notification_service.dart';
//
// class NotificationsView extends StatefulWidget {
//   const NotificationsView({super.key});
//
//   @override
//   State<NotificationsView> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationsView> {
//   final NotificationService notificationService = NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     notificationService.initialize();
//   }
//
//   void _scheduleMockNotification() {
//     final DateTime scheduledTime = DateTime.now().add(const Duration(seconds: 5));
//     notificationService.scheduleBedtimeNotification(
//       id: 0,
//       title: 'Bedtime Reminder',
//       body: 'Time to prepare for sleep!',
//       scheduledDate: scheduledTime,
//     );
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Notification scheduled!')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _scheduleMockNotification,
//           child: const Text('Schedule Notification'),
//         ),
//       ),
//     );
//   }
// }