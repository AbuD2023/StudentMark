import 'dart:developer';

import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/qr_code.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../config/constants.dart';
import '../../../departments/domain/models/department_model.dart';

class CoordinatorService {
  final Dio _dio;
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  CoordinatorService(this._dio, {required this.baseUrl}) {
    // _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized error
        }
        return handler.next(error);
      },
    ));
  }

  // Dashboard Statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Get all statistics in parallel
      final responses = await Future.wait([
        _dio.get('$baseUrl/api/student'),
        _dio.get('$baseUrl/api/department'),
        _dio.get('$baseUrl/api/level'),
        _dio.get('$baseUrl/api/subject'),
        _dio.get('$baseUrl/api/lectureSchedule/active'),
        // _dio.get('$baseUrl/api/lectureSchedule/active'),
        // _dio.get('$baseUrl/api/attendance/today'),
      ]);
      // responses.forEach(
      //   (element) {
      //     log(element.data.toString(), name: element.realUri.host);
      //   },
      // );

      // Extract data from responses
      final student = responses[0].data as List;
      final departments = responses[1].data as List;
      final levels = responses[2].data as List;
      final subjects = responses[3].data as List;
      final activeSchedules = responses[4].data as List;
      final todayAttendances = responses[4].data as List;

      // Get notifications from active schedules
      final notifications = activeSchedules.map((schedule) {
        return {
          'title': 'محاضرة نشطة',
          'message':
              'محاضرة ${schedule['courseSubject']['subject']['subjectName']} في ${schedule['department']['departmentName']}',
          'date': schedule['startTime'],
          'type': 'room',
        };
      }).toList();

      // Add attendance notifications
      if (todayAttendances.isNotEmpty) {
        notifications.add({
          'title': 'حضور اليوم',
          'message': 'تم تسجيل حضور ${todayAttendances.length} طالب اليوم',
          'date': DateTime.now().toIso8601String(),
          'type': 'attendance',
        });
      }

      return {
        'totalstudents': student.length,
        'totalDepartments': departments.length,
        'totalLevels': levels.length,
        'totalSubjects': subjects.length,
        'activeSchedules': activeSchedules.length,
        'todayAttendances': todayAttendances.length,
        'notifications': notifications,
      };
    } catch (e) {
      throw Exception('Failed to load dashboard statistics');
    }
  }

  // Student Operations
  Future<List<Student>> getAllstudent() async {
    try {
      final response = await _dio.get('$baseUrl/api/student');
      return (response.data as List)
          .map((json) => Student.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load student');
    }
  }

  Future<List<Student>> getActivestudent() async {
    try {
      final response = await _dio.get('$baseUrl/api/student/active');
      return (response.data as List)
          .map((json) => Student.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active student');
    }
  }

  Future<Student> getStudentById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/student/$id');
      return Student.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load student');
    }
  }

  Future<Student> getStudentWithUser(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/student/$id/with-user');
    return Student.fromJson(response.data);
  }

  Future<List<Student>> getstudentByDepartment(int departmentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/student/department/$departmentId');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Student>> getstudentByLevel(int levelId) async {
    final Response response =
        await _dio.get('$baseUrl/api/student/level/$levelId');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<List<Attendance>> getStudentAttendances(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/student/$id/attendances');
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getstudentchedules(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/student/$id/schedules');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<void> createStudent(Student student) async {
    try {
      await _dio.post('$baseUrl/api/student', data: student.toJson());
    } catch (e) {
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/student/${student.id}',
        data: {
          "userId": student.userId,
          "departmentId": student.departmentId,
          "levelId": student.levelId,
          "enrollmentYear": student.enrollmentYear
        },
      );
      log(response.data.toString(), name: 'updateStudent');
      // return response.data;
    } catch (e) {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(int id) async {
    try {
      await _dio.delete('$baseUrl/api/student/$id');
    } catch (e) {
      throw Exception('Failed to delete student');
    }
  }

  Future<void> togglestudenttatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/student/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle student status');
    }
  }

  // Department Operations
  Future<List<Department>> getAllDepartments() async {
    try {
      final response = await _dio.get('$baseUrl/api/department');
      return (response.data as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load departments');
    }
  }

  Future<List<Department>> getActiveDepartments() async {
    try {
      final response = await _dio.get('$baseUrl/api/department/active');
      return (response.data as List)
          .map((json) => Department.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active departments');
    }
  }

  Future<Department> getDepartmentById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/department/$id');
      return Department.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load department');
    }
  }

  Future<Department> getDepartmentWithLevels(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/department/$id/with-levels');
    return Department.fromJson(response.data);
  }

  Future<List<Course>> getDepartmentCourses(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/department/$id/courses');
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<List<Student>> getDepartmentstudent(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/department/$id/student');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<void> createDepartment(Department department) async {
    try {
      await _dio.post('$baseUrl/api/department', data: department.toJson());
    } catch (e) {
      throw Exception('Failed to create department');
    }
  }

  Future<void> updateDepartment(Department department) async {
    try {
      await _dio.put('$baseUrl/api/department/${department.id}',
          data: department.toJson());
    } catch (e) {
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await _dio.delete('$baseUrl/api/department/$id');
    } catch (e) {
      throw Exception('Failed to delete department');
    }
  }

  Future<void> toggleDepartmentStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/department/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle department status');
    }
  }

  // Level Operations
  Future<List<Level>> getAllLevels() async {
    try {
      final response = await _dio.get('$baseUrl/api/level');
      return (response.data as List)
          .map((json) => Level.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load levels');
    }
  }

  Future<List<Level>> getActiveLevels() async {
    try {
      final response = await _dio.get('$baseUrl/api/level/active');
      return (response.data as List)
          .map((json) => Level.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active levels');
    }
  }

  Future<List<Level>> getLevelsByDepartment(int departmentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/level/department/$departmentId');
    return (response.data as List).map((json) => Level.fromJson(json)).toList();
  }

  Future<Level> getLevelById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/level/$id');
      return Level.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load level');
    }
  }

  Future<List<Course>> getLevelCourses(int id) async {
    final Response response = await _dio.get('$baseUrl/api/level/$id/courses');
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<List<Student>> getLevelstudent(int id) async {
    final Response response = await _dio.get('$baseUrl/api/level/$id/student');
    return (response.data as List)
        .map((json) => Student.fromJson(json))
        .toList();
  }

  Future<void> createLevel(Level level) async {
    try {
      await _dio.post('$baseUrl/api/level', data: level.toJson());
    } catch (e) {
      throw Exception('Failed to create level');
    }
  }

  Future<void> updateLevel(Level level) async {
    try {
      await _dio.put('$baseUrl/api/level/${level.id}', data: level.toJson());
    } catch (e) {
      throw Exception('Failed to update level');
    }
  }

  Future<void> deleteLevel(int id) async {
    try {
      await _dio.delete('$baseUrl/api/level/$id');
    } catch (e) {
      throw Exception('Failed to delete level');
    }
  }

  Future<void> toggleLevelStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/level/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle level status');
    }
  }

  // Course Operations
  Future<List<Course>> getAllCourses() async {
    try {
      final response = await _dio.get('$baseUrl/api/courses');
      return (response.data as List)
          .map((json) => Course.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<Course>> getActiveCourses() async {
    try {
      final response = await _dio.get('$baseUrl/api/courses/active');
      return (response.data as List)
          .map((json) => Course.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active courses');
    }
  }

  Future<Course> getCourseById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/courses/$id');
      return Course.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course');
    }
  }

  Future<Course> getCourseWithSubjects(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/courses/$id/with-subjects');
    return Course.fromJson(response.data);
  }

  Future<List<Course>> getCoursesByDepartment(int departmentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/courses/department/$departmentId');
    return (response.data as List)
        .map((json) => Course.fromJson(json))
        .toList();
  }

  Future<void> createCourse(Course course) async {
    try {
      await _dio.post('$baseUrl/api/courses', data: course.toJson());
    } catch (e) {
      throw Exception('Failed to create course');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      await _dio.put('$baseUrl/api/courses/${course.id}',
          data: course.toJson());
    } catch (e) {
      throw Exception('Failed to update course');
    }
  }

  Future<void> deleteCourse(int id) async {
    try {
      await _dio.delete('$baseUrl/api/courses/$id');
    } catch (e) {
      throw Exception('Failed to delete course');
    }
  }

  Future<void> toggleCourseStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/courses/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle course status');
    }
  }

  // Subject Operations
  Future<List<Subject>> getAllSubjects() async {
    try {
      final response = await _dio.get('$baseUrl/api/subject');
      return (response.data as List)
          .map((json) => Subject.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load subjects');
    }
  }

  Future<List<Subject>> getActiveSubjects() async {
    try {
      final response = await _dio.get('$baseUrl/api/subject/active');
      return (response.data as List)
          .map((json) => Subject.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active subjects');
    }
  }

  Future<Subject> getSubjectById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/subject/$id');
      return Subject.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load subject');
    }
  }

  Future<Subject> getSubjectWithCourses(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/subject/$id/with-courses');
    return Subject.fromJson(response.data);
  }

  Future<void> createSubject(Subject subject) async {
    try {
      await _dio.post('$baseUrl/api/subject', data: subject.toJson());
    } catch (e) {
      throw Exception('Failed to create subject');
    }
  }

  Future<void> updateSubject(Subject subject) async {
    try {
      await _dio.put('$baseUrl/api/subject/${subject.id}',
          data: subject.toJson());
    } catch (e) {
      throw Exception('Failed to update subject');
    }
  }

  Future<void> deleteSubject(int id) async {
    try {
      await _dio.delete('$baseUrl/api/subject/$id');
    } catch (e) {
      throw Exception('Failed to delete subject');
    }
  }

  Future<void> toggleSubjectStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/subject/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle subject status');
    }
  }

  // Doctor Operations
  Future<List<DoctorDepartmentsLevels>> getAllDoctorAssignments() async {
    final Response response = await _dio.get('$baseUrl/api/doctors');
    return (response.data as List)
        .map((json) => DoctorDepartmentsLevels.fromJson(json))
        .toList();
  }

  Future<List<DoctorDepartmentsLevels>> getActiveDoctorAssignments() async {
    final Response response = await _dio.get('$baseUrl/api/doctors/active');
    return (response.data as List)
        .map((json) => DoctorDepartmentsLevels.fromJson(json))
        .toList();
  }

  Future<DoctorDepartmentsLevels> getDoctorAssignmentById(int id) async {
    final Response response = await _dio.get('$baseUrl/api/doctors/$id');
    return DoctorDepartmentsLevels.fromJson(response.data);
  }

  Future<List<DoctorDepartmentsLevels>> getAssignmentsByDoctor(
      int doctorId) async {
    final Response response =
        await _dio.get('$baseUrl/api/doctors/doctor/$doctorId');
    return (response.data as List)
        .map((json) => DoctorDepartmentsLevels.fromJson(json))
        .toList();
  }

  Future<List<DoctorDepartmentsLevels>> getAssignmentsByDepartment(
      int departmentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/doctors/department/$departmentId');
    return (response.data as List)
        .map((json) => DoctorDepartmentsLevels.fromJson(json))
        .toList();
  }

  Future<List<DoctorDepartmentsLevels>> getAssignmentsByLevel(
      int levelId) async {
    final Response response =
        await _dio.get('$baseUrl/api/doctors/level/$levelId');
    return (response.data as List)
        .map((json) => DoctorDepartmentsLevels.fromJson(json))
        .toList();
  }

  Future<DoctorDepartmentsLevels> createDoctorAssignment(
      DoctorDepartmentsLevels assignment) async {
    final Response response =
        await _dio.post('$baseUrl/api/doctors', data: assignment.toJson());
    return DoctorDepartmentsLevels.fromJson(response.data);
  }

  Future<void> updateDoctorAssignment(
      DoctorDepartmentsLevels assignment) async {
    await _dio.put('$baseUrl/api/doctors/${assignment.id}',
        data: assignment.toJson());
  }

  Future<void> deleteDoctorAssignment(int id) async {
    await _dio.delete('$baseUrl/api/doctors/$id');
  }

  Future<void> toggleDoctorAssignmentStatus(int id) async {
    await _dio.put('$baseUrl/api/doctors/$id/toggle-status');
  }

  // Lecture Schedule Operations
  Future<List<LectureSchedule>> getAllSchedules() async {
    try {
      final response = await _dio.get('$baseUrl/api/lectureSchedule');
      return (response.data as List)
          .map((json) => LectureSchedule.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load lecture schedules');
    }
  }

  Future<List<LectureSchedule>> getActiveSchedules() async {
    try {
      final response = await _dio.get('$baseUrl/api/lectureSchedule/active');
      return (response.data as List)
          .map((json) => LectureSchedule.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active lecture schedules');
    }
  }

  Future<LectureSchedule> getScheduleById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/lectureSchedule/$id');
      return LectureSchedule.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load lecture schedule');
    }
  }

  Future<List<LectureSchedule>> getSchedulesByDoctor(int doctorId) async {
    final Response response =
        await _dio.get('$baseUrl/api/lectureSchedule/doctor/$doctorId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getSchedulesByCourseSubject(
      int courseSubjectId) async {
    final Response response = await _dio
        .get('$baseUrl/api/lectureSchedule/course-subject/$courseSubjectId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getSchedulesByDepartment(
      int departmentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/lectureSchedule/department/$departmentId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getSchedulesByLevel(int levelId) async {
    final Response response =
        await _dio.get('$baseUrl/api/lectureSchedule/level/$levelId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<QRCode>> getScheduleQRCodes(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/lectureSchedule/$id/qrcodes');
    return (response.data as List)
        .map((json) => QRCode.fromJson(json))
        .toList();
  }

  Future<List<Attendance>> getScheduleAttendances(int id) async {
    final Response response =
        await _dio.get('$baseUrl/api/lectureSchedule/$id/attendances');
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<void> createSchedule(LectureSchedule schedule) async {
    try {
      await _dio.post('$baseUrl/api/lectureSchedule', data: schedule.toJson());
    } catch (e) {
      throw Exception('Failed to create lecture schedule');
    }
  }

  Future<void> updateSchedule(LectureSchedule schedule) async {
    try {
      await _dio.put('$baseUrl/api/lectureSchedule/${schedule.id}',
          data: schedule.toJson());
    } catch (e) {
      throw Exception('Failed to update lecture schedule');
    }
  }

  Future<void> deleteSchedule(int id) async {
    try {
      await _dio.delete('$baseUrl/api/lectureSchedule/$id');
    } catch (e) {
      throw Exception('Failed to delete lecture schedule');
    }
  }

  Future<void> toggleScheduleStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/lectureSchedule/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle lecture schedule status');
    }
  }

  // QR Code Operations
  Future<QRCode> generateQRCode(int scheduleId) async {
    try {
      final response = await _dio.post('$baseUrl/api/qr-codes/generate',
          data: {'scheduleId': scheduleId});
      return QRCode.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate QR code');
    }
  }

  Future<List<QRCode>> getActiveQRCodes() async {
    final Response response = await _dio.get('$baseUrl/api/qr-codes/active');
    return (response.data as List)
        .map((json) => QRCode.fromJson(json))
        .toList();
  }

  Future<List<QRCode>> getExpiredQRCodes() async {
    final Response response = await _dio.get('$baseUrl/api/qr-codes/expired');
    return (response.data as List)
        .map((json) => QRCode.fromJson(json))
        .toList();
  }

  Future<void> cancelQRCode(int id) async {
    try {
      await _dio.put('$baseUrl/api/qr-codes/$id/cancel');
    } catch (e) {
      throw Exception('Failed to cancel QR code');
    }
  }

  Future<QRCode> getQRCodeBySchedule(int scheduleId) async {
    final Response response =
        await _dio.get('$baseUrl/api/qr-codes/schedule/$scheduleId');
    return QRCode.fromJson(response.data);
  }

  // Report Operations
  Future<List<Attendance>> generateAttendanceReport(
    DateTime startDate,
    DateTime endDate, {
    int? departmentId,
    int? levelId,
    int? doctorId,
    int? studentId,
    int? courseSubjectId,
  }) async {
    final Response response =
        await _dio.post('$baseUrl/api/reports/attendance', data: {
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "departmentId": departmentId,
      "levelId": levelId,
      "doctorId": doctorId,
      "studentId": studentId,
      "courseSubjectId": courseSubjectId,
    });
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> generateStudentAttendanceReport(
      int studentId, DateTime startDate, DateTime endDate) async {
    final Response response =
        await _dio.post('$baseUrl/api/reports/student-attendance', data: {
      "studentId": studentId,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
    });
    return response.data;
  }

  Future<List<LectureSchedule>> generateDoctorScheduleReport(
    int doctorId, {
    int? departmentId,
    int? levelId,
    int? courseSubjectId,
  }) async {
    final Response response =
        await _dio.post('$baseUrl/api/reports/doctor-schedule', data: {
      "doctorId": doctorId,
      "departmentId": departmentId,
      "levelId": levelId,
      "courseSubjectId": courseSubjectId,
    });
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> generateDepartmentStatistics(
      int departmentId, DateTime startDate, DateTime endDate) async {
    final Response response =
        await _dio.post('$baseUrl/api/reports/department-statistics', data: {
      "departmentId": departmentId,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
    });
    return response.data;
  }

  Future<Map<String, dynamic>> generateLevelStatistics(
      int levelId, DateTime startDate, DateTime endDate) async {
    final Response response =
        await _dio.post('$baseUrl/api/reports/level-statistics', data: {
      "levelId": levelId,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
    });
    return response.data;
  }

  Future<List<Attendance>> getAttendanceBySchedule(int scheduleId) async {
    final Response response =
        await _dio.get('$baseUrl/api/attendance/schedule/$scheduleId');
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<List<Attendance>> getAttendanceByStudent(int studentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/attendance/student/$studentId');
    return (response.data as List)
        .map((json) => Attendance.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> getAttendanceReport({
    int? departmentId,
    int? levelId,
    int? courseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Response response =
        await _dio.get('$baseUrl/api/reports/attendance', queryParameters: {
      if (departmentId != null) 'departmentId': departmentId,
      if (levelId != null) 'levelId': levelId,
      if (courseId != null) 'courseId': courseId,
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getStudentReport(int studentId) async {
    final Response response =
        await _dio.get('$baseUrl/api/reports/student/$studentId');
    return response.data;
  }
}
