import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favList = provider.favoriteCourses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursus Favorit Saya'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: favList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada kursus favorit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favList.length,
              itemBuilder: (context, index) {
                final course = favList[index];
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
                    isFavorite: true,
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