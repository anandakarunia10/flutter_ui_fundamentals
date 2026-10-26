import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final response = await supabase
        .from('courses')
        .select()
        .order('id', ascending: true);

    final List<dynamic> data = response as List<dynamic>;

    return data
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase
        .from('courses')
        .update(course.toJson())
        .eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await supabase
        .from('courses')
        .delete()
        .eq('id', id);
  }
}