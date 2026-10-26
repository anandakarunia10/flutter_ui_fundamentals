import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/add_course_dialog.dart';
import 'screens/courses_list_page.dart';
import 'screens/favorites_page.dart';
import 'screens/home_page.dart';
import 'screens/main_screen.dart';
import 'services/course_api_service.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

void main() {
  final courseApiService = CourseApiService(apiBaseUrl);
  final courseRepository = CourseRepository(courseApiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}