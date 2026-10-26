import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';

class CoursesListPage extends StatelessWidget {
  const CoursesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // 1. Loading State
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 2. Error State
    if (provider.error != null) {
      return ErrorView(
        message: provider.error!,
        onRetry: () => provider.loadCourses(),
      );
    }

    // 3. Empty State
    if (provider.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'Data course belum tersedia.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => provider.loadCourses(),
              child: const Text('Refresh Data'),
            ),
          ],
        ),
      );
    }

    // 4. Success State
    return RefreshIndicator(
      onRefresh: () => provider.loadCourses(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.courses.length,
        itemBuilder: (context, index) {
          final course = provider.courses[index];
          final isFav = provider.isFavorite(course.code);

          return CourseCard(
            course: course,
            isFavorite: isFav,
            onFavoriteToggle: () => provider.toggleFavorite(course.code),
          );
        },
      ),
    );
  }
}