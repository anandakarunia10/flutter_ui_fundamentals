import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/main_screen.dart';
import 'services/course_api_service.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

// Isikan URL Proyek & Anon Key Supabase kamu dari Dashboard Supabase
const String supabaseUrl = 'https://bgvhjtvpypyvuqxxqxin.supabase.co';
const String supabaseAnonKey = 'ss';

const String apiBaseUrl = 'https://jsonplaceholder.typicode.com';

Future<void> main() async {
  // Wajib dipanggil sebelum inisialisasi async pada main()
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase Client
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Perakitan REST API Service (masih digunakan sampai Tahap 11)
  final repository = CourseRepository(CourseApiService(apiBaseUrl));

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
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