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
      title: 'Tahap 1 - Local vs Shared State',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const StateIdentificationPage(),
    );
  }
}

class StateIdentificationPage extends StatefulWidget {
  const StateIdentificationPage({super.key});

  @override
  State<StateIdentificationPage> createState() => _StateIdentificationPageState();
}

class _StateIdentificationPageState extends State<StateIdentificationPage> {
  bool _showDetails = false;
  bool _isLocalFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 1 - Local vs Shared State'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('NIM: $studentId'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'MOB01 - Dart Fundamentals',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isLocalFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isLocalFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isLocalFavorite = !_isLocalFavorite;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showDetails = !_showDetails;
                        });
                      },
                      icon: Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
                      label: Text(_showDetails ? 'Sembunyikan Detail' : 'Tampilkan Detail'),
                    ),
                    if (_showDetails) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.grey.shade100,
                        child: const Text(
                          'Deskripsi: Mempelajari dasar pemrograman Dart, OOP, dan asynchronous programming.',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Identifikasi 5 State Aplikasi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildStateInfoTile(
              title: '1. Show/Hide Detail Kursus',
              type: 'Local State',
              reason: 'Hanya dibutuhkan oleh satu komponen kartu untuk visibilitas teks.',
            ),
            _buildStateInfoTile(
              title: '2. Status Input Teks Pencarian',
              type: 'Local State',
              reason: 'Nilai sementara pada komponen form pencarian sebelum diproses.',
            ),
            _buildStateInfoTile(
              title: '3. Daftar Kursus Favorit',
              type: 'Shared State',
              reason: 'Dibutuhkan bersama oleh halaman Daftar, Detail, dan Favorites.',
            ),
            _buildStateInfoTile(
              title: '4. Profil/Identitas Pengguna',
              type: 'Shared State',
              reason: 'Diakses di header serta halaman profil pada seluruh bagian aplikasi.',
            ),
            _buildStateInfoTile(
              title: '5. Indeks Tab Navigasi Aktif',
              type: 'Shared State',
              reason: 'Mengontrol tampilan halaman utama pada shell navigasi.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateInfoTile({
    required String title,
    required String type,
    required String reason,
  }) {
    final isShared = type.contains('Shared');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Alasan: $reason'),
        trailing: Chip(
          label: Text(type, style: const TextStyle(fontSize: 12)),
          backgroundColor: isShared ? Colors.orange.shade100 : Colors.blue.shade100,
        ),
      ),
    );
  }
}