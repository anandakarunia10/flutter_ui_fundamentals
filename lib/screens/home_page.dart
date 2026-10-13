import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/student_header_card.dart';
import 'course_detail_page.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return SingleChildScrollView(
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
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Courses',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.courses.length}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Favorites',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.favorites.length}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (provider.isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (provider.error != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${provider.error}', style: TextStyle(color: Colors.red.shade900)),
              ),
            )
          else ...[
            const Text(
              'Ringkasan Kursus Aktif:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...provider.courses.map((course) {
              final isFav = provider.isFavorite(course.code);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailPage(course: course),
                    ),
                  );
                },
                child: CourseCard(
                  code: course.code,
                  title: course.title,
                  credits: course.credits,
                  status: course.status,
                  isFavorite: isFav,
                  onFavoriteToggle: () {
                    context.read<CourseProvider>().toggleFavorite(course.code);
                  },
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}