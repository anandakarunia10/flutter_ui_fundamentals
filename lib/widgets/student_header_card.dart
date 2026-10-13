import 'package:flutter/material.dart';

class StudentHeaderCard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final int favoriteCount;

  const StudentHeaderCard({
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