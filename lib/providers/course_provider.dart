import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> _courses = [];
  final Set<String> _favorites = {};
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  Set<String> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Course> get favoriteCourses =>
      _courses.where((course) => _favorites.contains(course.code)).toList();

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi membuat Course baru via HTTP POST / Supabase INSERT
  Future<bool> addCourse(Course course) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final createdCourse = await repository.createCourse(course);
      _courses.insert(0, createdCourse); // Tambahkan ke baris paling atas
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi memperbarui Course via HTTP PUT / Supabase UPDATE (Tahap 14)
  Future<bool> updateCourse(int id, Course updatedCourse) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, updatedCourse);
      await loadCourses(); // Reload agar list UI sinkron dengan database
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi menghapus Course via HTTP DELETE / Supabase DELETE (Tahap 15)
  Future<bool> deleteCourse(int id, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await repository.deleteCourse(id);
      _courses.removeWhere((c) => c.id == id);
      _favorites.remove(code); // Hapus dari favorit agar tidak tersisa data yatim
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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