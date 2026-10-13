import 'dart:convert';
import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    await Future.delayed(const Duration(milliseconds: 600));

    const String mockJsonData = '''
    {
      "courses": [
        {"code": "MOB01", "title": "Dart Fundamentals", "credits": 3, "status": "done"},
        {"code": "MOB02", "title": "Flutter UI Dasar", "credits": 4, "status": "done"},
        {"code": "MOB03", "title": "State Management", "credits": 3, "status": "active"}
      ]
    }
    ''';

    final data = jsonDecode(mockJsonData) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}