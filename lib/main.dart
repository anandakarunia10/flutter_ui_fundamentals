import 'package:flutter/material.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 4 - Expanded, Flexible, Wrap',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const FlexWrapDemoPage(),
    );
  }
}

class FlexWrapDemoPage extends StatelessWidget {
  const FlexWrapDemoPage({super.key});

  final List<String> skills = const [
    'Flutter',
    'Dart',
    'Responsive Design',
    'State Management',
    'REST API',
    'Git & GitHub',
    'Clean Architecture',
  ];

  Widget _buildBox(String label, Color color) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - Flex & Wrap'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Pembagian Ruang Proporsional (Expanded Flex 2:1)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Panel Row dengan Expanded Flex 2:1
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBox('Panel Utama (Flex: 2)', Colors.deepPurple),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _buildBox('Panel Samping (Flex: 1)', Colors.indigo),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              '2. Penanganan Elemen Dinamis (Wrap vs Row)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Wrap widget untuk chip skill agar turun baris saat layar sempit
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: skills
                  .map(
                    (skill) => Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: const Icon(Icons.check, size: 14, color: Colors.deepPurple),
                      ),
                      label: Text(skill),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}