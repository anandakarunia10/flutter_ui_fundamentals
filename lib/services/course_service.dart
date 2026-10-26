
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  bool simulateError = false;

  static const String apiUrl =
      'https://jsonplaceholder.typicode.com/posts/1';

  Future<void> testHttpGet({
    required String studentName,
    required String studentId,
  }) async {
    debugPrint('Nama: $studentName');
    debugPrint('NIM: $studentId');

    final response = await http.get(Uri.parse(apiUrl));

    debugPrint('HTTP Method: GET');
    debugPrint('Endpoint: $apiUrl');
    debugPrint('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint('Response berhasil diterima');
      debugPrint('Jumlah field JSON: ${data.length}');
      debugPrint('userId: ${data['userId']}');
      debugPrint('id: ${data['id']}');
      debugPrint('title: ${data['title']}');
      debugPrint('body: ${data['body']}');
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  Future<List<Course>> loadCourses() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (simulateError) {
      throw Exception(
        'Sengaja dipicu: Gagal mengambil data dari server (Debug Mode).',
      );
    }

    const String mockJsonData = '''
    {
      "courses": [
        {"code": "MOB01", "title": "Git & GitHub", "credits": 2, "status": "done"},
        {"code": "MOB02", "title": "Dart Fundamentals", "credits": 3, "status": "done"},
        {"code": "MOB03", "title": "State Management", "credits": 3, "status": "active"},
        {"code": "MOB04", "title": "Flutter UI Responsive", "credits": 3, "status": "done"},
        {"code": "MOB05", "title": "Clean Architecture", "credits": 4, "status": "active"}
      ]
    }
    ''';

    final data = jsonDecode(mockJsonData) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
