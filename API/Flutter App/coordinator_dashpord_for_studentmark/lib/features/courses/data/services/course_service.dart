import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants.dart';

class CourseService {
  final ApiService _apiService;

  CourseService(this._apiService);

  Future<List<Course>> getAllCourses() async {
    final Response response = await _apiService.get(AppConstants.courses);
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<Course> getCourseById(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.courses}/$id');
    return Course.fromJson(response.data);
  }

  Future<List<Course>> getCoursesByDepartment(int departmentId) async {
    final Response response = await _apiService
        .get('${AppConstants.courses}/department/$departmentId');
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<List<Course>> getCoursesByLevel(int levelId) async {
    final Response response =
        await _apiService.get('${AppConstants.courses}/level/$levelId');
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<Course> createCourse(Course course) async {
    final Response response = await _apiService.post(
      AppConstants.courses,
      data: course.toJson(),
    );
    return Course.fromJson(response.data);
  }

  Future<Course> updateCourse(Course course) async {
    final Response response = await _apiService.put(
      '${AppConstants.courses}/${course.id}',
      data: course.toJson(),
    );
    return Course.fromJson(response.data);
  }

  Future<void> deleteCourse(int id) async {
    await _apiService.delete('${AppConstants.courses}/$id');
  }

  Future<void> toggleCourseStatus(int id) async {
    await _apiService.put('${AppConstants.courses}/$id/toggle-status');
  }
}
