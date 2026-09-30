import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// Konstanta Identitas Mahasiswa
const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

// Fungsi asinkron pembaca data JSON lokal
Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const LearningDashboardApp());
}

class LearningDashboardApp extends StatelessWidget {
  const LearningDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    // Memastikan pemanggilan data asinkron hanya diinisialisasi 1 kali
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // 1. Kondisi Loading / Waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // 2. Kondisi Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Gagal memuat data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            // 3. Kondisi Data Siap
            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            // Kalkulasi Agregasi Statistik
            final int totalCourses = courses.length;
            final int completedCourses = courses.where((c) => c['status'] == 'done').length;
            final int totalCredits = courses.fold<int>(
              0,
              (sum, item) => sum + ((item['credits'] as num?)?.toInt() ?? 0),
            );
            final int progressPercent = totalCourses > 0 
                ? ((completedCourses / totalCourses) * 100).round() 
                : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reusable Widget 1: Kartu Profil & Identitas
                  _buildProfileCard(student),
                  const SizedBox(height: 14),

                  // Reusable Widget 2: Baris Ringkasan Capaian (Summary Cards)
                  Row(
                    children: [
                      _buildSummaryCard('Topik', '$totalCourses', Icons.menu_book, Colors.blue),
                      const SizedBox(width: 8),
                      _buildSummaryCard('Total SKS', '$totalCredits', Icons.school, Colors.indigo),
                      const SizedBox(width: 8),
                      _buildSummaryCard('Progress', '$progressPercent%', Icons.check_circle, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Daftar Materi Pembelajaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Daftar Mata Kuliah Dinamis
                  Expanded(
                    child: ListView.separated(
                      itemCount: courses.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        return _buildCourseCard(course);
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      'Data list dimuat dari JSON statik',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // REUSABLE WIDGET / HELPER FUNCTIONS
  // ==========================================

  // 1. Reusable Widget Profil Mahasiswa
  Widget _buildProfileCard(Map<String, dynamic> student) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade50,
            backgroundImage: const AssetImage('assets/images/profile.jpg'),
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.person, size: 32, color: Colors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'] ?? studentName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'NIM: ${student['nim'] ?? studentId}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${student['program']} • ${student['semester']}',
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Reusable Widget Kartu Ringkasan (Summary Card)
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Reusable Widget Item Kursus dengan Conditional UI
  Widget _buildCourseCard(Map<String, dynamic> course) {
    final String status = course['status'] ?? 'planned';
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (status == 'done') {
      statusColor = Colors.green;
      statusLabel = 'Selesai';
      statusIcon = Icons.check_circle_outline;
    } else if (status == 'active') {
      statusColor = Colors.orange;
      statusLabel = 'Berjalan';
      statusIcon = Icons.play_circle_outline;
    } else {
      statusColor = Colors.grey;
      statusLabel = 'Rencana';
      statusIcon = Icons.schedule;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(statusIcon, color: statusColor, size: 22),
        ),
        title: Text(
          course['title'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${course['code']} • ${course['credits']} SKS',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            if (course['lecturer'] != null)
              Text(
                'Dosen: ${course['lecturer']}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: statusColor.withOpacity(0.4)),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ),
      ),
    );
  }
}