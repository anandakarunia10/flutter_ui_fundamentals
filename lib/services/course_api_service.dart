import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;
  bool simulateError = false;

  Future<List<Course>> getCourses() async {
    if (simulateError) {
      throw Exception(
        'Sengaja dipicu: Gagal mengambil data dari server (Debug Mode).',
      );
    }

    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts'
        : '$baseUrl/courses';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course: HTTP ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Metode HTTP POST untuk membuat Course baru
  Future<Course> createCourse(Course newCourse) async {
    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts'
        : '$baseUrl/courses';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(newCourse.toJson()),
    );

    debugPrint('HTTP Method: POST');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      
      // Jika server dummy tidak mengembalikan field lokal, pertahankan nilai input
      return Course(
        id: data['id'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        code: newCourse.code,
        title: newCourse.title,
        credits: newCourse.credits,
        status: newCourse.status,
      );
    } else {
      throw Exception(
        'Gagal menambah course baru (Status: ${response.statusCode})',
      );
    }
  }
}