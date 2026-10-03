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
      title: 'Tahap 8 - Passing Data',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CourseListPage(),
    );
  }
}

// 1. HALAMAN DAFTAR KURSUS (Pengirim Data)
class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  final List<Map<String, dynamic>> courses = const [
    {
      'code': 'MOB01',
      'title': 'Dart Fundamentals',
      'credits': 3,
      'status': 'Selesai',
      'description': 'Mempelajari dasar bahasa pemrograman Dart, OOP, dan asynchronous programming.',
    },
    {
      'code': 'MOB02',
      'title': 'Flutter UI Dasar',
      'credits': 3,
      'status': 'Selesai',
      'description': 'Mengenal widget dasar, Container, Row, Column, dan tata letak UI statis.',
    },
    {
      'code': 'MOB03',
      'title': 'State Management',
      'credits': 3,
      'status': 'Sedang Berjalan',
      'description': 'Pengelolaan state lokal dan reaktif pada Flutter menggunakan StatefulWidget.',
    },
    {
      'code': 'MOB04',
      'title': 'Responsive Layout',
      'credits': 3,
      'status': 'Sedang Berjalan',
      'description': 'Membangun antarmuka multi-device menggunakan LayoutBuilder dan MediaQuery.',
    },
    {
      'code': 'MOB05',
      'title': 'Flutter Navigation',
      'credits': 2,
      'status': 'Terjadwal',
      'description': 'Navigasi layar, stack management, passing data, dan adaptive routing.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8 - Daftar Kursus'),
      ),
      body: Column(
        children: [
          // Header Identitas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.indigo.shade50,
            child: Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // List Course
          Expanded(
            child: ListView.separated(
              itemCount: courses.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(course['code'].toString().substring(3)),
                  ),
                  title: Text(
                    course['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${course['code']} • ${course['credits']} SKS'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(course: course),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 2. HALAMAN DETAIL KURSUS (Penerima Data via Constructor)
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa di Halaman Detail
            Card(
              color: Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: Colors.indigo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Praktikan: $studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              course['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text('Kode: ${course['code']}')),
                const SizedBox(width: 8),
                Chip(label: Text('${course['credits']} SKS')),
                const SizedBox(width: 8),
                Chip(
                  label: Text('${course['status']}'),
                  backgroundColor: Colors.indigo.shade100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Pembelajaran:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              course['description'],
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}