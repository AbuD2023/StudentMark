import 'dart:developer';

import 'package:coordinator_dashpord_for_studentmark/config/constants.dart';
import 'package:dio/dio.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorService {
  final Dio _dio;
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  DoctorService(this._dio, {required this.baseUrl}) {
    // _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(minutes: 3);
    _dio.options.receiveTimeout = const Duration(minutes: 3);
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

  // Get all doctor assignments
  Future<List<Doctor>> getAllDoctorAssignments() async {
    try {
      final response = await _dio.get('$baseUrl/api/doctor');
      return (response.data as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load doctor assignments');
    }
  }

  // Get active doctor assignments
  Future<List<Doctor>> getActiveDoctorAssignments() async {
    try {
      final response = await _dio.get('$baseUrl/api/doctor/active');
      return (response.data as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load active doctor assignments');
    }
  }

  // Get doctor assignment by ID
  Future<Doctor> getDoctorAssignmentById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/doctor/$id');
      return Doctor.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load doctor assignment');
    }
  }

  // Get assignments by doctor ID
  Future<List<Doctor>> getAssignmentsByDoctor(int doctorId) async {
    try {
      final response = await _dio.get('$baseUrl/api/doctor/doctor/$doctorId');
      return (response.data as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load doctor assignments');
    }
  }

  // Get assignments by department ID
  Future<List<Doctor>> getAssignmentsByDepartment(int departmentId) async {
    try {
      final response =
          await _dio.get('$baseUrl/api/doctor/department/$departmentId');
      return (response.data as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load department doctor assignments');
    }
  }

  // Get assignments by level ID
  Future<List<Doctor>> getAssignmentsByLevel(int levelId) async {
    try {
      final response = await _dio.get('$baseUrl/api/doctor/level/$levelId');
      return (response.data as List)
          .map((json) => Doctor.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load level doctor assignments');
    }
  }

  // Create doctor assignment
  Future<Doctor> createDoctorAssignment(Doctor doctor) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/doctor',
        data: {
          'doctorId': doctor.doctorId,
          'departmentId': doctor.departmentId,
          'levelId': doctor.levelId,
        },
      );
      return Doctor.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          final message = e.response?.data['message'] as String?;
          throw Exception(message ?? 'Invalid doctor assignment data');
        }
      }
      throw Exception('Failed to create doctor assignment');
    }
  }

  // Update doctor assignment
  Future<void> updateDoctorAssignment(Doctor doctor) async {
    try {
      await _dio.put(
        '$baseUrl/api/doctor/${doctor.id}',
        data: {
          'doctorId': doctor.doctorId,
          'departmentId': doctor.departmentId,
          'levelId': doctor.levelId,
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          final message = e.response?.data['message'] as String?;
          throw Exception(message ?? 'Invalid doctor assignment data');
        }
      }
      throw Exception('Failed to update doctor assignment');
    }
  }

  // Delete doctor assignment
  Future<void> deleteDoctorAssignment(int id) async {
    try {
      await _dio.delete('$baseUrl/api/doctor/$id');
    } catch (e) {
      throw Exception('Failed to delete doctor assignment');
    }
  }

  // Toggle doctor assignment status
  Future<void> toggleDoctorAssignmentStatus(int id) async {
    try {
      await _dio.put('$baseUrl/api/doctor/$id/toggle-status');
    } catch (e) {
      throw Exception('Failed to toggle doctor assignment status');
    }
  }

  // Get all departments
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

  // Get active departments
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

  // Get levels by department
  Future<List<Level>> getLevelsByDepartment(int departmentId) async {
    try {
      final response =
          await _dio.get('$baseUrl/api/level/department/$departmentId');
      return (response.data as List)
          .map((json) => Level.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load department levels');
    }
  }

  // Create new doctor user
  Future<String> createDoctorUser(User user) async {
    try {
      final response = await _dio.post('$baseUrl/api/auth/register', data: {
        "username": user.username,
        "email": user.email,
        "password": user.password,
        "fullName": user.fullName,
        "roleId": 2, // Doctor role ID
      });
      log('${response.data['message']},${response.data['id']}',
          name: 'createDoctorUser');
      return '${response.data['message']},${response.data['id']}';
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          final message = e.response?.data['message'] as String?;
          throw Exception(message ?? 'Invalid doctor data');
        }
      }
      throw Exception('Failed to create doctor user');
    }
  }

  // Get all doctor users
  Future<List<User>> getAllDoctorUsers() async {
    try {
      final response = await _dio.get('$baseUrl/api/user/doctorUser');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load doctor users');
    }
  }

  // Get unassigned doctor users
  Future<List<User>> getUnassignedDoctorUsers() async {
    try {
      final response = await _dio.get('$baseUrl/api/user/unassigned-doctors');
      return (response.data as List)
          .map((json) => User.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load unassigned doctor users');
    }
  }
}
