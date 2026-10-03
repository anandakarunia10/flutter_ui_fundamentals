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
      title: 'Tahap 5 - Responsive GridView',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ResponsiveGridPage(),
    );
  }
}

class ResponsiveGridPage extends StatelessWidget {
  const ResponsiveGridPage({super.key});

  // Data dummy course (minimal 5 item)
  final List<Map<String, dynamic>> courses = const [
    {
      'code': 'MOB01',
      'title': 'Dart Fundamentals',
      'status': 'Completed',
      'color': Colors.blue,
    },
    {
      'code': 'MOB02',
      'title': 'Flutter UI Dasar',
      'status': 'Completed',
      'color': Colors.green,
    },
    {
      'code': 'MOB03',
      'title': 'State Management',
      'status': 'Active',
      'color': Colors.orange,
    },
    {
      'code': 'MOB04',
      'title': 'Responsive Layout',
      'status': 'Active',
      'color': Colors.teal,
    },
    {
      'code': 'MOB05',
      'title': 'Flutter Navigation',
      'status': 'Planned',
      'color': Colors.deepPurple,
    },
    {
      'code': 'MOB06',
      'title': 'API & Database Integration',
      'status': 'Planned',
      'color': Colors.redAccent,
    },
  ];

  // Fungsi penentu jumlah kolom berdasarkan breakpoint lebar layar
  int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - Responsive GridView'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columnCount = columnsFor(constraints.maxWidth);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header identitas mahasiswa
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Kolom: $columnCount (Lebar: ${constraints.maxWidth.toStringAsFixed(0)} px)',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // GridView responsif
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: columnCount == 1 ? 3.0 : 2.0,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final item = courses[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: item['color'] as Color,
                                foregroundColor: Colors.white,
                                child: Text((item['code'] as String).substring(3)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Kode: ${item['code']} • ${item['status']}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}