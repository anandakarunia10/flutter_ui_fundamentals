
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

    debugPrint('[FCM] Authorization: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('[FCM] Izin notifikasi diberikan');

      await getFCMToken();
      listenTokenRefresh();
    } else {
      debugPrint('[FCM] Izin notifikasi ditolak');
    }
  }

  Future<void> getFCMToken() async {
    final String? token = await _fcm.getToken();

    debugPrint('[FCM Token] $token');
  }

  void listenTokenRefresh() {
    _fcm.onTokenRefresh.listen((String token) {
      debugPrint('[FCM Token Refresh] $token');
    });
  }
}
