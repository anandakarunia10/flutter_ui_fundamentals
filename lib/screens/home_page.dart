import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_header_card.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        title: const Text('Tahap 12 - Refactor Folder Structure'),
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
            StudentHeaderCard(
              studentName: studentName,
              studentId: studentId,
              favoriteCount: provider.favorites.length,
            ),
            const SizedBox(height: 16),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(provider.error!, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )
            else ...[
              const Text(
                'Daftar Kursus (Modular Folder Architecture):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ...provider.courses.map((course) {
                final isFav = provider.isFavorite(course.code);
                return CourseCard(
                  code: course.code,
                  title: course.title,
                  credits: course.credits,
                  status: course.status,
                  isFavorite: isFav,
                  onFavoriteToggle: () {
                    context.read<CourseProvider>().toggleFavorite(course.code);
                  },
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}