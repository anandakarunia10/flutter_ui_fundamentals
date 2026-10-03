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
      title: 'Tahap 7 - Navigation Dasar',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
    );
  }
}

// 1. SKRIN UTAMA (HomePage)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - Home Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kad Pengenalan Diri
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 50, color: Colors.indigo),
                      const SizedBox(height: 8),
                      Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text('Skrin: Home Page (Halaman Utama)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Butang Navigasi ke DetailPage via Navigator.push
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Detail Page'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. SKRIN TERPERINCI (DetailPage)
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - Detail Page'),
        // Butang kembali automatik (Leading Back Icon) disediakan secara lalai oleh Flutter
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Identiti: $studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Anda kini berada di DetailPage.\nTimbunan skrin berjaya ditambah melalui Navigator.push().',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Butang Manual untuk Kembali via Navigator.pop
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali (Navigator.pop)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}