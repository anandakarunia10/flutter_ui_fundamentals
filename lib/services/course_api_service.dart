import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  CourseApiService(this.baseUrl);

  final String baseUrl;
  bool simulateError = false;

  @override
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

  @override
  Future<Course> createCourse(Course course) async {
    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts'
        : '$baseUrl/courses';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Course(
        id: data['id'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        code: course.code,
        title: course.title,
        credits: course.credits,
        status: course.status,
      );
    } else {
      throw Exception(
        'Gagal menambah course baru (Status: ${response.statusCode})',
      );
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts/$id'
        : '$baseUrl/courses/$id';

    final response = await http.put(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui course HTTP ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    final String endpoint = baseUrl.contains('jsonplaceholder')
        ? '$baseUrl/posts/$id'
        : '$baseUrl/courses/$id';

    final response = await http.delete(Uri.parse(endpoint));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus course HTTP ${response.statusCode}');
    }
  }
}