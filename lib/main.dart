import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

class Course {
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [
    Course.fromJson({
      'code': 'MOB01',
      'title': 'Dart Fundamentals',
      'credits': 3,
      'status': 'done',
    }),
    Course.fromJson({
      'code': 'MOB02',
      'title': 'Flutter UI Dasar',
      'credits': 4,
      'status': 'done',
    }),
    Course.fromJson({
      'code': 'MOB03',
      'title': 'State Management',
      'credits': 3,
      'status': 'active',
    }),
  ];

  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  Set<String> get favorites => _favorites;

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 8 - Model Course',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ModelDemoPage(),
    );
  }
}

class ModelDemoPage extends StatelessWidget {
  const ModelDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8 - Model Course'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 40, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            studentName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text('NIM: $studentId'),
                        ],
                      ),
                    ),
                    Chip(
                      avatar: const Icon(Icons.favorite, color: Colors.red, size: 18),
                      label: Text('${provider.favorites.length} Favorit'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar Kursus (Parsed via Model Course):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...provider.courses.map((course) {
              final isFav = provider.isFavorite(course.code);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${course.code} • ${course.credits} SKS'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(
                          course.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: course.status == 'done' ? Colors.green.shade800 : Colors.blue.shade800,
                          ),
                        ),
                        backgroundColor: course.status == 'done' ? Colors.green.shade50 : Colors.blue.shade50,
                      ),
                      IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<CourseProvider>().toggleFavorite(course.code);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}