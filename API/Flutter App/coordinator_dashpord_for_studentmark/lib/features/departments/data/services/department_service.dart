// import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
// import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
// import 'package:dio/dio.dart';

// import '../../../../config/constants.dart';
// import '../../../../core/models/course.dart';
// import '../../../../core/models/level.dart';
// import '../../../../core/models/student.dart';
// import '../../../../core/models/subject.dart';

// class DepartmentService {
//   final ApiService _apiService;
//   // final String _basePath = '/departments';

//   DepartmentService(this._apiService);

//   Future<List<Department>> getAllDepartments() async {
//     final Response response = await _apiService.get(AppConstants.departments);
//     return (response.data as List)
//         .map((json) => Department.fromJson(json))
//         .toList();
//   }

//   Future<List<Department>> getActiveDepartments() async {
//     final Response response =
//         await _apiService.get('${AppConstants.departments}/active');
//     return (response.data as List)
//         .map((json) => Department.fromJson(json))
//         .toList();
//   }

//   Future<Department> getDepartmentById(int id) async {
//     final Response response =
//         await _apiService.get('${AppConstants.departments}/$id');
//     return Department.fromJson(response.data);
//   }

//   Future<Department> getDepartmentWithLevels(int id) async {
//     final Response response =
//         await _apiService.get('${AppConstants.departments}/$id/with-levels');
//     return Department.fromJson(response.data);
//   }

//   Future<List<Course>> getDepartmentCourses(int id) async {
//     final Response response =
//         await _apiService.get('${AppConstants.departments}/$id/courses');
//     return (response.data as List)
//         .map((json) => Course.fromJson(json))
//         .toList();
//   }

//   Future<List<Student>> getDepartmentStudents(int id) async {
//     final Response response =
//         await _apiService.get('${AppConstants.departments}/$id/students');
//     return (response.data as List)
//         .map((json) => Student.fromJson(json))
//         .toList();
//   }

//   Future<Department> createDepartment(Department department) async {
//     final Response response = await _apiService.post(
//       AppConstants.departments,
//       data: {
//         "departmentName": department.departmentName,
//         "description": department.description,
//       },
//     );
//     return Department.fromJson(response.data);
//   }

//   Future<void> updateDepartment(Department department) async {
//     await _apiService.put(
//       '${AppConstants.departments}/${department.id}',
//       data: {
//         "departmentName": department.departmentName,
//         "description": department.description,
//       },
//     );
//   }

//   Future<void> toggleDepartmentStatus(int id) async {
//     await _apiService.put('${AppConstants.departments}/$id/toggle-status');
//   }

//   Future<void> deleteDepartment(int id) async {
//     await _apiService.delete('${AppConstants.departments}/$id');
//   }

//   // Additional methods based on the ASP.NET controller
//   Future<List<Level>> getDepartmentLevels(int departmentId) async {
//     final Response response = await _apiService
//         .get('${AppConstants.departments}/$departmentId/levels');
//     return (response.data as List).map((json) => Level.fromJson(json)).toList();
//   }

//   Future<List<Subject>> getDepartmentSubjects(int departmentId) async {
//     final Response response = await _apiService
//         .get('${AppConstants.departments}/$departmentId/subjects');
//     return (response.data as List)
//         .map((json) => Subject.fromJson(json))
//         .toList();
//   }
// }
