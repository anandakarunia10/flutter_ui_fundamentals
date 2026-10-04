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
      title: 'Course Explorer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ResponsiveShell(),
    );
  }
}

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _courseList = [
    {
      'code': 'MOB01',
      'title': 'Dart Fundamentals',
      'status': 'Completed',
      'credits': 3,
      'isFavorite': false,
      'description': 'Mempelajari dasar pemrograman Dart, type system, OOP, dan asynchronous programming.',
    },
    {
      'code': 'MOB02',
      'title': 'Flutter UI Dasar',
      'status': 'Completed',
      'credits': 3,
      'isFavorite': false,
      'description': 'Konstruksi widget dasar, tata letak statis, Row, Column, Container, dan asset management.',
    },
    {
      'code': 'MOB03',
      'title': 'State Management',
      'status': 'Active',
      'credits': 3,
      'isFavorite': true,
      'description': 'Pengelolaan reaktivitas state aplikasi menggunakan pendekatan setState dan Provider pattern.',
    },
    {
      'code': 'MOB04',
      'title': 'Responsive Layout',
      'credits': 3,
      'status': 'Active',
      'isFavorite': true,
      'description': 'Membangun antarmuka adaptif berbagai layar menggunakan MediaQuery, LayoutBuilder, dan constraints.',
    },
    {
      'code': 'MOB05',
      'title': 'Navigation & Interaction',
      'credits': 2,
      'status': 'Planned',
      'isFavorite': false,
      'description': 'Mekanisme perpindahan antar layar, passing data constructor, gesture handling, dan snackbar feedback.',
    },
    {
      'code': 'MOB06',
      'title': 'API & Database Integration',
      'credits': 4,
      'status': 'Planned',
      'isFavorite': false,
      'description': 'Komunikasi HTTP RESTful service, parsing JSON dinamis, dan persistensi SQLite lokal.',
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _courseList[index]['isFavorite'] = !_courseList[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 600;

        final List<Widget> pages = [
          HomeView(
            courses: _courseList,
            onCourseTap: (course, index) => _openDetail(course, index),
          ),
          CoursesView(
            courses: _courseList,
            onToggleFavorite: _toggleFavorite,
            onCourseTap: (course, index) => _openDetail(course, index),
          ),
          const ProfileView(),
        ];

        if (isExpanded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer (Expanded Layout)'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: pages[_currentIndex]),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: pages[_currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
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
      },
    );
  }

  Future<void> _openDetail(Map<String, dynamic> course, int index) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    );

    if (result != null && mounted) {
      if (result != course['isFavorite']) {
        _toggleFavorite(index);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result
                ? '${course['title']} ditambahkan ke favorit!'
                : '${course['title']} dihapus dari favorit.',
          ),
          backgroundColor: result ? Colors.green : Colors.blueGrey,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class HomeView extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Function(Map<String, dynamic>, int) onCourseTap;

  const HomeView({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'NIM: $studentId',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daftar Kursus Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length > 3 ? 3 : courses.length,
            itemBuilder: (context, idx) {
              final c = courses[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text(c['code'].toString().substring(3))),
                  title: Text(c['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${c['code']} • Status: ${c['status']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => onCourseTap(c, idx),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CoursesView extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Function(int) onToggleFavorite;
  final Function(Map<String, dynamic>, int) onCourseTap;

  const CoursesView({
    super.key,
    required this.courses,
    required this.onToggleFavorite,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 900 ? 2 : 3);
        final double aspectRatio = constraints.maxWidth < 600 ? 2.6 : 1.8;

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final item = courses[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onCourseTap(item, index),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            item['code'].toString().substring(3),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['code']} • ${item['status']}',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            item['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: item['isFavorite'] ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => onToggleFavorite(index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late bool _favStatus;

  @override
  void initState() {
    super.initState();
    _favStatus = widget.course['isFavorite'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course['title']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _favStatus),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.badge, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text('Praktikan: $studentId - $studentName',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.course['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Kode: ${widget.course['code']}')),
                Chip(label: Text('${widget.course['credits']} SKS')),
                Chip(
                  label: Text('${widget.course['status']}'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Pembelajaran:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.course['description'],
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(_favStatus ? Icons.favorite : Icons.favorite_border),
              label: Text(_favStatus ? 'Tersimpan di Favorit' : 'Tambah ke Favorit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _favStatus ? Colors.pink.shade50 : null,
                foregroundColor: _favStatus ? Colors.pink : null,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                setState(() => _favStatus = !_favStatus);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Konfirmasi Pengiriman'),
          content: Text('Kirimkan masukan evaluasi dari $studentName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _commentController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Feedback berhasil dikirimkan!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 40)),
                  const SizedBox(height: 12),
                  Text(studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('NIM: $studentId', style: const TextStyle(color: Colors.blue)),
                  const Divider(height: 24),
                  const Text('Prodi: Teknologi Rekayasa Perangkat Lunak'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Beri Ulasan Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Komentar Evaluasi',
                    hintText: 'Minimal 5 karakter ulasan...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 5) {
                      return 'Komentar wajib minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: _submitFeedback,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}