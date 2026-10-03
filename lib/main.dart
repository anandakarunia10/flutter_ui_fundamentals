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
      title: 'Pertemuan 5 - Tahap 1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NonResponsiveDemoPage(),
    );
  }
}

class NonResponsiveDemoPage extends StatelessWidget {
  const NonResponsiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 1 - Hard-coded vs Flexible'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uji 1: Hard-coded Width (500 px)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // KASUS 1: Hard-coded width 500 px
            // Masalah: jika layar < 500px (misal layar smartphone), akan terjadi overflow atau terpotong
            Container(
              width: 500,
              padding: const EdgeInsets.all(16),
              color: Colors.amber.shade200,
              child: Text(
                '$studentId - $studentName (Hard-coded 500px)',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Uji 2: Flexible Width (double.infinity)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            // KASUS 2: Solusi Flexible width
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade200,
              child: Text(
                '$studentId - $studentName (Flexible / Mengisi Lebar)',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}