import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  // Untuk menguji tampilan error pada aplikasi
  bool simulateError = false;

  Future<List<Course>> getCourses() async {
    if (simulateError) {
      throw Exception(
        'Sengaja dipicu: Gagal mengambil data dari server (Debug Mode).',
      );
    }

    // Menggunakan /posts jika menggunakan jsonplaceholder agar tidak 404
    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts'
        : '$baseUrl/courses';

    final response = await http.get(Uri.parse(endpoint));

    debugPrint('HTTP Method: GET');
    debugPrint('Endpoint: $endpoint');
    debugPrint('Status Code: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil course: HTTP ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    debugPrint('Jumlah course: ${data.length}');

    return data
        .map(
          (item) => Course.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}