import 'dart:convert';
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

// SERVICE / DATA SOURCE LAYER
class CourseService {
  Future<List<Course>> loadCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
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

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];
  final Set<String> _favorites = {};
  bool _isLoading = true;

  List<Course> get courses => _courses;
  Set<String> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> initData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await _courseService.loadCourses();
    } catch (e) {
      debugPrint('Error loading courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
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
      title: 'Tahap 9 - Course Service',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ServiceDemoPage(),
    );
  }
}

class ServiceDemoPage extends StatefulWidget {
  const ServiceDemoPage({super.key});

  @override
  State<ServiceDemoPage> createState() => _ServiceDemoPageState();
}

class _ServiceDemoPageState extends State<ServiceDemoPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil initData() secara aman tepat setelah frame pertama selesai di-render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 9 - Course Service'),
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
            if (provider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              const Text(
                'Daftar Kursus (Dimuat via CourseService):',
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
          ],
        ),
      ),
    );
  }
}