import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Gede Ananda Karunia Putra';
const String studentId = '2455011010';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 6 - Provider Setup',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ProviderDemoPage(),
    );
  }
}

class ProviderDemoPage extends StatelessWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Provider Setup'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 40, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            studentName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text('NIM: $studentId'),
                        ],
                      ),
                    ),
                    Chip(
                      avatar: const Icon(Icons.favorite, color: Colors.red, size: 18),
                      label: Text('${courseProvider.favorites.length} Favorit'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('MOB01 - Dart Fundamentals', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('MOB01'),
                trailing: IconButton(
                  icon: Icon(
                    courseProvider.isFavorite('MOB01') ? Icons.favorite : Icons.favorite_border,
                    color: courseProvider.isFavorite('MOB01') ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => courseProvider.toggleFavorite('MOB01'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('MOB02 - Flutter UI Dasar', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('MOB02'),
                trailing: IconButton(
                  icon: Icon(
                    courseProvider.isFavorite('MOB02') ? Icons.favorite : Icons.favorite_border,
                    color: courseProvider.isFavorite('MOB02') ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => courseProvider.toggleFavorite('MOB02'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('MOB03 - State Management', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('MOB03'),
                trailing: IconButton(
                  icon: Icon(
                    courseProvider.isFavorite('MOB03') ? Icons.favorite : Icons.favorite_border,
                    color: courseProvider.isFavorite('MOB03') ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => courseProvider.toggleFavorite('MOB03'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}