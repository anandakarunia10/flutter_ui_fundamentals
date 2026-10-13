import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String code;
  final String title;
  final int credits;
  final String status;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseCard({
    super.key,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$code • $credits SKS'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: status == 'done' ? Colors.green.shade800 : Colors.blue.shade800,
                ),
              ),
              backgroundColor: status == 'done' ? Colors.green.shade50 : Colors.blue.shade50,
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}