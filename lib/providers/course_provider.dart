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

  // GETTER UNTUK MENGAMBIL DAFTAR KURSUS FAVORIT
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