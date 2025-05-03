import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';
import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants.dart';

class StudentService {
  final ApiService _apiService;

  StudentService(this._apiService);

  Future<List<Student>> getAllStudents() async {
    final Response response = await _apiService.get(AppConstants.students);
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Student>> getActiveStudents() async {
    final Response response =
        await _apiService.get('${AppConstants.students}/active');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<Student> getStudentById(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.students}/$id');
    return Student.fromJson(response.data);
  }

  Future<Student> getStudentWithUser(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.students}/$id/with-user');
    return Student.fromJson(response.data);
  }

  Future<List<Student>> getStudentsByDepartment(int departmentId) async {
    final Response response = await _apiService
        .get('${AppConstants.students}/department/$departmentId');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Student>> getStudentsByLevel(int levelId) async {
    final Response response =
        await _apiService.get('${AppConstants.students}/level/$levelId');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Attendance>> getStudentAttendances(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.students}/$id/attendances');
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getStudentSchedules(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.students}/$id/schedules');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<Student> createStudent(Student student) async {
    final Response response = await _apiService.post(
      AppConstants.students,
      data: {
        "userId": student.userId,
        "departmentId": student.departmentId,
        "levelId": student.levelId,
        "enrollmentYear": student.enrollmentYear,
      },
    );
    return Student.fromJson(response.data);
  }

  Future<void> updateStudent(Student student) async {
    await _apiService.put(
      '${AppConstants.students}/${student.id}',
      data: {
        "userId": student.userId,
        "departmentId": student.departmentId,
        "levelId": student.levelId,
        "enrollmentYear": student.enrollmentYear,
      },
    );
  }

  Future<void> deleteStudent(int id) async {
    await _apiService.delete('${AppConstants.students}/$id');
  }

  Future<void> toggleStudentStatus(int id) async {
    await _apiService.put('${AppConstants.students}/$id/toggle-status');
  }
}
