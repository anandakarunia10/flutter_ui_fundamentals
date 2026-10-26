
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/main_screen.dart';
import 'services/course_service.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

  // Pengujian HTTP GET Tahap 2.
  courseService
      .testHttpGet(
        studentName: studentName,
        studentId: studentId,
      )
      .catchError((error) {
        debugPrint('HTTP GET gagal: $error');
      });

  // Pengujian konversi model Tahap 3.
  const sampleCourse = Course(
    id: 1,
    code: 'MOB01',
    title: 'Git & GitHub',
    credits: 2,
    status: 'done',
  );

  final jsonData = sampleCourse.toJson();
  debugPrint('Course toJson: $jsonData');

  final parsedCourse = Course.fromJson(jsonData);
  debugPrint('Course fromJson: ${parsedCourse.title}');
  debugPrint('Course code: ${parsedCourse.code}');
  debugPrint('Course credits: ${parsedCourse.credits}');
  debugPrint('Course status: ${parsedCourse.status}');

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository),
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
