import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesListPage extends StatelessWidget {
  const CoursesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.courses.length,
              itemBuilder: (context, index) {
                final course = provider.courses[index];
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
              },
            ),
    );
  }
}