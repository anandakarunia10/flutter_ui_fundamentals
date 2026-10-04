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
      title: 'Tahap 14 - Feedback UI',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const FeedbackDemoPage(),
    );
  }
}

class FeedbackDemoPage extends StatefulWidget {
  const FeedbackDemoPage({super.key});

  @override
  State<FeedbackDemoPage> createState() => _FeedbackDemoPageState();
}

class _FeedbackDemoPageState extends State<FeedbackDemoPage> {
  bool _isLoading = false;
  String _actionStatus = 'Belum ada aksi yang diproses.';

  // Fungsi menampilkan konfirmasi Dialog lalu simulasi proses async
  Future<void> _handleConfirmAction() async {
    // 1. TAMPILKAN ALERTDIALOG KONFIRMASI
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Pendaftaran'),
          content: Text(
            'Apakah Anda yakin ingin mendaftarkan kursus ini atas nama $studentName ($studentId)?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ya, Daftarkan'),
            ),
          ],
        );
      },
    );

    // Jika pengguna memilih "Ya, Daftarkan"
    if (confirmed == true && mounted) {
      setState(() {
        _isLoading = true;
        _actionStatus = 'Sedang memproses pendaftaran...';
      });

      // 2. SIMULASI PROSES DENGAN LOADING INDICATOR (2 Detik)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _actionStatus = 'Berhasil terdaftar pada batch praktikum aktif!';
        });

        // 3. TAMPILKAN FEEDBACK SNACKBAR
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pendaftaran untuk $studentName berhasil disimpan!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 14 - Dialog & SnackBar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kartu Identitas Mahasiswa
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.notifications_active, size: 50, color: Colors.indigo),
                      const SizedBox(height: 8),
                      Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Status: $_actionStatus',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Tampilan Tombol Aksi atau Indikator Loading
              if (_isLoading)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Menyimpan data ke server...'),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _handleConfirmAction,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Daftar Kursus Sekarang'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}