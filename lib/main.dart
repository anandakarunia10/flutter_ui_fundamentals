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
      title: 'Tahap 13 - Form & Validation',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const FeedbackFormPage(),
    );
  }
}

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  // GlobalKey untuk mengontrol state dan validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller form dengan nilai default identitas
  final TextEditingController _nameController = TextEditingController(text: studentName);
  final TextEditingController _idController = TextEditingController(text: studentId);
  final TextEditingController _commentController = TextEditingController();

  String _submittedResult = '';

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Memeriksa apakah seluruh validator mengembalikan null (lolos validasi)
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submittedResult =
            'Terkirim: ${_commentController.text} (Oleh: ${_nameController.text} - ${_idController.text})';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Formulir berhasil divalidasi dan disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13 - Form & Validasi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kartu Header Identitas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.rate_review, size: 48, color: Colors.indigo),
                    const SizedBox(height: 8),
                    Text(
                      '$studentId - $studentName',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Text('Form Evaluasi & Feedback Course'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 1. Field Nama Mahasiswa (Default)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama mahasiswa wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Field NIM Mahasiswa (Default)
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'NIM Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Field Komentar Feedback (Wajib Minimal 5 Karakter)
              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar Feedback',
                  hintText: 'Tuliskan minimal 5 karakter ulasan...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  }
                  if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Feedback'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 20),

              // Tampilan Hasil Submit
              if (_submittedResult.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    _submittedResult,
                    style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}