
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> initNotification() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: ${settings.authorizationStatus.name}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await getToken();

      listenTokenRefresh((token) {
        saveTokenToSupabase(token).catchError((error) {
          debugPrint('[FCM] Gagal menyimpan token refresh: $error');
        });
      });
    }
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();

    debugPrint('[FCM Token] $token');

    return token;
  }

  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('[FCM] Token diperbarui');
      onRefresh(newToken);
    });
  }

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
