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
      title: 'Tahap 3 - LayoutBuilder Breakpoint',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const BreakpointDemoPage(),
    );
  }
}

class BreakpointDemoPage extends StatelessWidget {
  const BreakpointDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Breakpoint LayoutBuilder'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Logika Breakpoint Praktikum
          if (constraints.maxWidth < 600) {
            return CompactLayout(width: constraints.maxWidth);
          } else if (constraints.maxWidth < 840) {
            return MediumLayout(width: constraints.maxWidth);
          } else {
            return ExpandedLayout(width: constraints.maxWidth);
          }
        },
      ),
    );
  }
}

// 1. COMPACT LAYOUT (< 600 px) - Smartphone
class CompactLayout extends StatelessWidget {
  final double width;
  const CompactLayout({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade50,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone_android, size: 64, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            '$studentId - $studentName',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text('Kategori: COMPACT LAYOUT (< 600 px)',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
          Text('Lebar Terukur: ${width.toStringAsFixed(1)} px'),
        ],
      ),
    );
  }
}

// 2. MEDIUM LAYOUT (600 - 839 px) - Tablet Portrait
class MediumLayout extends StatelessWidget {
  final double width;
  const MediumLayout({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange.shade50,
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.tablet, size: 80, color: Colors.orange),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text('Kategori: MEDIUM LAYOUT (600 - 839 px)',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
              Text('Lebar Terukur: ${width.toStringAsFixed(1)} px'),
            ],
          )
        ],
      ),
    );
  }
}

// 3. EXPANDED LAYOUT (>= 840 px) - Desktop / Tablet Landscape
class ExpandedLayout extends StatelessWidget {
  final double width;
  const ExpandedLayout({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade50,
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.teal.shade100,
              child: const Center(
                child: Icon(Icons.desktop_windows, size: 96, color: Colors.teal),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$studentId - $studentName',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 12),
                const Text('Kategori: EXPANDED LAYOUT (>= 840 px)',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal, fontSize: 16)),
                Text('Lebar Terukur: ${width.toStringAsFixed(1)} px'),
                const SizedBox(height: 8),
                const Text('Layout multi-panel aktif (Expanded flex 1:2)'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}