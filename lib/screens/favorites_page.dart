import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favList = provider.favoriteCourses;

    if (favList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Belum ada mata kuliah favorit.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favList.length,
      itemBuilder: (context, index) {
        final course = favList[index];
        return CourseCard(
          course: course,
          isFavorite: true,
          onFavoriteToggle: () => provider.toggleFavorite(course.code),
        );
      },
    );
  }
}