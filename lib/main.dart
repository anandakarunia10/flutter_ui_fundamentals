import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

// 1. MODEL LAYER
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

// 2. SERVICE LAYER
class CourseService {
  bool shouldSimulateError = false;

  Future<List<Course>> loadCourses() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (shouldSimulateError) {
      throw Exception('Gagal menghubungkan ke server data kursus.');
    }

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

// 3. REPOSITORY LAYER
class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}

// 4. PROVIDER LAYER (MANAJEMEN ASYNC STATE)
class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> _courses = [];
  final Set<String> _favorites = {};
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  Set<String> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
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
  final courseService = CourseService();
  final courseRepository = CourseRepository(courseService);

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
      title: 'Tahap 11 - Async State',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const AsyncStateDemoPage(),
    );
  }
}

class AsyncStateDemoPage extends StatefulWidget {
  const AsyncStateDemoPage({super.key});

  @override
  State<AsyncStateDemoPage> createState() => _AsyncStateDemoPageState();
}

class _AsyncStateDemoPageState extends State<AsyncStateDemoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 11 - Async State Provider'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang',
            onPressed: () {
              context.read<CourseProvider>().loadCourses();
            },
          )
        ],
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
            const SizedBox(height: 16),
            // SIKLUS TAMPILAN KONDISI ASYNC STATE
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Memuat data kursus...'),
                    ],
                  ),
                ),
              )
            else if (provider.error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal Memuat Data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<CourseProvider>().loadCourses();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              const Text(
                'Daftar Kursus (Kondisi Success):',
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