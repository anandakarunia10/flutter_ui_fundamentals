import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.favoriteCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Favorit'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text(
                'Belum ada course favorit.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];
                return CourseCard(course: course);
              },
            ),
    );
  }
}