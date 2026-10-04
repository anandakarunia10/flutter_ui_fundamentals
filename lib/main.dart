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
      title: 'Tahap 12 - User Interaction',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const InteractionDemoPage(),
    );
  }
}

class InteractionDemoPage extends StatefulWidget {
  const InteractionDemoPage({super.key});

  @override
  State<InteractionDemoPage> createState() => _InteractionDemoPageState();
}

class _InteractionDemoPageState extends State<InteractionDemoPage> {
  // State interaksi
  bool _isFavorite = false;
  int _tapCount = 0;
  String _gestureFeedback = 'Belum ada interaksi gesture.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12 - User Interaction'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Identitas Mahasiswa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.touch_app, size: 48, color: Colors.indigo),
                  const SizedBox(height: 8),
                  Text(
                    '$studentId - $studentName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text('Uji Coba: InkWell, Button, & GestureDetector'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // KARTU INTERAKTIF DENGAN INKWELL DAN GESTUREDETECTOR
            Material(
              color: Colors.white,
              elevation: 3,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.indigo.shade100,
                // Aksi Tap Biasa pada InkWell
                onTap: () {
                  setState(() {
                    _tapCount++;
                    _gestureFeedback = 'Kartu diketuk (Tap ke-$_tapCount) via InkWell';
                  });
                },
                // Aksi Long Press (Tekan Lama)
                onLongPress: () {
                  setState(() {
                    _gestureFeedback = 'Long Press terdeteksi! Detail cepat ditampilkan.';
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            child: Text('04'),
                          ),
                          // Tombol Favorite Interaktif
                          IconButton(
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                            tooltip: 'Tandai Favorit',
                            onPressed: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                                _gestureFeedback = _isFavorite
                                    ? 'Ditambahkan ke Favorit via IconButton'
                                    : 'Dihapus dari Favorit';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'MOB04 - Responsive Layout & Interaction',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Status Favorite: ${_isFavorite ? "FAVORIT SAYA" : "Bukan Favorit"}',
                        style: TextStyle(
                          color: _isFavorite ? Colors.red.shade700 : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Tips: Tap kartu untuk ripple effect, atau tahan lama (Long Press).',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // AREA INDIKATOR STATUS INTERAKSI
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.indigo),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _gestureFeedback,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}