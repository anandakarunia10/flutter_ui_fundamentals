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
      title: 'Tahap 6 - Scrollable & Keyboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ScrollableFormPage(),
    );
  }
}

class ScrollableFormPage extends StatelessWidget {
  const ScrollableFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Scrollable Content'),
      ),
      // SingleChildScrollView mencegah "Bottom overflowed by XX pixels" saat keyboard muncul
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Identitas Mahasiswa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo),
              ),
              child: Column(
                children: [
                  const Icon(Icons.account_circle, size: 60, color: Colors.indigo),
                  const SizedBox(height: 8),
                  Text(
                    '$studentId - $studentName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const Text('Form Profil Pengguna Mahasiswa'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Fields berurutan ke bawah
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email Kampus',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Program Studi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Bio / Catatan',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            // Field uji keyboard di bagian paling bawah layar
            const TextField(
              decoration: InputDecoration(
                labelText: 'Uji Keyboard (Fokus ke sini)',
                hintText: 'Keyboard akan mengangkat viewport ini',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.keyboard),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Simpan Data Profil'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}