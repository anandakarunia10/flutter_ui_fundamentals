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
      title: 'Tahap 9 - Returning Data',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CourseSelectionPage(),
    );
  }
}

// 1. HALAMAN UTAMA (Menunggu dan Menerima Hasil Kembalian)
class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  String statusFavorit = 'Belum ada kursus yang difavoritkan.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 9 - Returning Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.stars, size: 50, color: Colors.orange),
                      const SizedBox(height: 8),
                      Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: $statusFavorit',
                        style: const TextStyle(fontSize: 14, color: Colors.indigo),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Buka Detail & Pilih Kursus'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () async {
                  // MENUNGGU HASIL KEMBALIAN (AWAIT RESULT)
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CourseConfirmPage(
                        courseTitle: 'Flutter Responsive & Navigation',
                      ),
                    ),
                  );

                  // JIKA RESULT == TRUE, TAMPILKAN SNACKBAR DAN PERBARUI STATE
                  if (result == true && mounted) {
                    setState(() {
                      statusFavorit = 'Kursus telah berhasil ditambahkan ke Favorit!';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil: Kursus disimpan ke daftar favorit!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. HALAMAN DETAIL (Mengirim Data Kembali via Navigator.pop)
class CourseConfirmPage extends StatelessWidget {
  final String courseTitle;

  const CourseConfirmPage({
    super.key,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail & Konfirmasi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Identitas: $studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 16),
              Text(
                courseTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Tekan tombol di bawah untuk menyukai dan mengirim sinyal konfirmasi kembali ke halaman sebelumnya.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Pilih / Favorite'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    // MENGEMBALIKAN NILAI TRUE KE SCREEN SEBELUMNYA
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}