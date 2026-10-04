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
      title: 'Tahap 16 - Debugging Challenge',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DebuggingChallengePage(),
    );
  }
}

class DebuggingChallengePage extends StatefulWidget {
  const DebuggingChallengePage({super.key});

  @override
  State<DebuggingChallengePage> createState() => _DebuggingChallengePageState();
}

class _DebuggingChallengePageState extends State<DebuggingChallengePage> {
  bool _isNavigating = false;

  void _safeNavigate() {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Detail Aman')),
          body: const Center(child: Text('Halaman tidak terbuka ganda')),
        ),
      ),
    ).then((_) {
      if (mounted) setState(() => _isNavigating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 - Debugging Challenge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
            const Text(
              'Solusi Kasus A: Row Overflow Teks Panjang (Fixed via Expanded)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$studentId - $studentName - Teks informasi materi responsive mobile layout yang sangat panjang dan kini otomatis membungkus rapi ke bawah.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Solusi Kasus B: ListView dalam Column (Fixed via SizedBox / shrinkWrap)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 140,
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Item 1: Viewport dibatasi SizedBox'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Item 2: Bebas unbounded height error'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Solusi Kasus D: Pencegahan Navigasi Ganda (Guard Flag)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isNavigating ? null : _safeNavigate,
              icon: const Icon(Icons.shield),
              label: Text(_isNavigating ? 'Memproses...' : 'Uji Tombol Anti Dobel Klik'),
            ),
          ],
        ),
      ),
    );
  }
}