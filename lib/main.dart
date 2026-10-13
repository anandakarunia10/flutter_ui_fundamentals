import 'package:flutter/material.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 3 - Lifting State Up',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const LiftingStateUpPage(),
    );
  }
}

class LiftingStateUpPage extends StatefulWidget {
  const LiftingStateUpPage({super.key});

  @override
  State<LiftingStateUpPage> createState() => _LiftingStateUpPageState();
}

class _LiftingStateUpPageState extends State<LiftingStateUpPage> {
  final Set<String> _favoriteCourses = {};

  void _toggleFavorite(String code) {
    setState(() {
      if (_favoriteCourses.contains(code)) {
        _favoriteCourses.remove(code);
      } else {
        _favoriteCourses.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Lifting State Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HeaderSummaryCard(
              studentName: studentName,
              studentId: studentId,
              favoriteCount: _favoriteCourses.length,
            ),
            const SizedBox(height: 16),
            FavoritesOverviewCard(
              favoriteCodes: _favoriteCourses.toList(),
            ),
            const SizedBox(height: 16),
            CourseCard(
              code: 'MOB01',
              title: 'Dart Fundamentals',
              isFavorite: _favoriteCourses.contains('MOB01'),
              onFavoriteChanged: () => _toggleFavorite('MOB01'),
            ),
            CourseCard(
              code: 'MOB02',
              title: 'Flutter UI Dasar',
              isFavorite: _favoriteCourses.contains('MOB02'),
              onFavoriteChanged: () => _toggleFavorite('MOB02'),
            ),
            CourseCard(
              code: 'MOB03',
              title: 'State Management',
              isFavorite: _favoriteCourses.contains('MOB03'),
              onFavoriteChanged: () => _toggleFavorite('MOB03'),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSummaryCard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final int favoriteCount;

  const HeaderSummaryCard({
    super.key,
    required this.studentName,
    required this.studentId,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('NIM: $studentId'),
                ],
              ),
            ),
            Chip(
              avatar: const Icon(Icons.favorite, color: Colors.red, size: 18),
              label: Text('$favoriteCount Favorit'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesOverviewCard extends StatelessWidget {
  final List<String> favoriteCodes;

  const FavoritesOverviewCard({
    super.key,
    required this.favoriteCodes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                favoriteCodes.isEmpty
                    ? 'Belum ada kursus yang difavoritkan'
                    : 'Favorit Aktif: ${favoriteCodes.join(", ")}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String code;
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.code,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(code),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteChanged,
        ),
      ),
    );
  }
}