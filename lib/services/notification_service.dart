
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_keys.dart';
import '../firebase_options.dart';

// Handler harus berada di luar class.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('[BACKGROUND] ${message.notification?.title}');
  debugPrint('[BACKGROUND] ${message.notification?.body}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  // Inisialisasi seluruh fitur notifikasi.
  Future<void> init() async {
    await requestPermission();

    final token = await getToken();

    if (token != null) {
      await saveTokenToSupabase(token);
    }

    listenTokenRefresh(saveTokenToSupabase);

    // Pengaturan tampilan notifikasi saat aplikasi foreground (iOS).
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listener saat aplikasi sedang dibuka.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');
      debugPrint('data : ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
        ),
      );
    });
  }

  // Meminta izin notifikasi.
  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      '[FCM] Notification permission: '
      '${settings.authorizationStatus.name}',
    );
  }

  // Mengambil FCM token perangkat.
  Future<String?> getToken() async {
    final token = await _messaging.getToken();

    debugPrint('[FCM Token] $token');

    return token;
  }

  // Memantau perubahan FCM token.
  void listenTokenRefresh(
    void Function(String token) onRefresh,
  ) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] Token diperbarui');
      onRefresh(newToken);
    });
  }

  // Menyimpan atau memperbarui token ke Supabase.
  Future<void> saveTokenToSupabase(String token) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      debugPrint('[FCM] User belum login. Token tidak disimpan.');
      return;
    }

    await _supabase.from('device_tokens').upsert({
      'token': token,
      'user_id': user.id,
      'platform': defaultTargetPlatform.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });

    debugPrint('[FCM] Token berhasil disimpan ke Supabase');
  }
}
