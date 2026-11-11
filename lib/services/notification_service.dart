
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    final NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      '[FCM] Authorization Status: ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('[FCM] Izin notifikasi diberikan');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('[FCM] Izin notifikasi provisional');
    } else {
      debugPrint('[FCM] Izin notifikasi ditolak');
    }
  }
}
