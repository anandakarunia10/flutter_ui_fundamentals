import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isFav = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.code);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.code,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Chip(
                          label: Text(
                            course.status,
                            style: TextStyle(
                              color: course.status == 'done'
                                  ? Colors.green.shade800
                                  : Colors.blue.shade800,
                            ),
                          ),
                          backgroundColor: course.status == 'done'
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Beban Studi: ${course.credits} SKS',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 30),
                    Row(
                      children: [
                        Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFav
                              ? 'Kursus ini ada di daftar favorit Anda'
                              : 'Kursus ini belum difavoritkan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isFav ? Colors.red.shade700 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFav ? Colors.red.shade100 : Colors.blue.shade100,
                  foregroundColor: isFav ? Colors.red.shade900 : Colors.blue.shade900,
                ),
                onPressed: () {
                  context.read<CourseProvider>().toggleFavorite(course.code);
                },
                icon: Icon(isFav ? Icons.favorite_border : Icons.favorite),
                label: Text(
                  isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}