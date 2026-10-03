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
      title: 'Tahap 10 - NavigationBar',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  // State untuk melacak tab aktif
  int _currentIndex = 0;

  // Daftar halaman berdasarkan tab
  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Navigasi Utama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Menampilkan halaman sesuai index yang dipilih
      body: _pages[_currentIndex],
      // Navigasi bawah Material 3
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// 1. HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard_customize, size: 70, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Selamat Datang di Course Explorer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikasi Mobile Praktikum 5\n$studentId - $studentName',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. COURSES SCREEN
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> subjects = [
      'MOB01 - Dart Fundamentals',
      'MOB02 - Flutter UI',
      'MOB03 - State Management',
      'MOB04 - Responsive Layout',
      'MOB05 - Navigation & Routing',
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(subjects[index]),
            subtitle: const Text('Status: Aktif'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }
}

// 3. PROFILE SCREEN (Identitas Lengkap)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 45),
                ),
                const SizedBox(height: 16),
                Text(
                  studentName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: $studentId',
                  style: const TextStyle(fontSize: 14, color: Colors.indigo),
                ),
                const Divider(height: 28),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.school, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Teknologi Rekayasa Perangkat Lunak'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}