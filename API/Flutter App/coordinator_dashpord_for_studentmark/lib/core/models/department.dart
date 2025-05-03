// import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
// import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';

// class Department {
//   final int id;
//   final String departmentName;
//   final String? description;
//   final bool isActive;
//   // final DateTime createdAt;
//   // final DateTime? updatedAt;

//   // Navigation properties
//   final List<Level>? levels;
//   final List<Course>? courses;
//   final List<Student>? students;
//   final List<DoctorDepartmentsLevels>? doctorDepartmentsLevels;
//   final List<LectureSchedule>? lectureSchedules;

//   Department({
//     required this.id,
//     required this.departmentName,
//     this.description,
//     required this.isActive,
//     // required this.createdAt,
//     // this.updatedAt,
//     this.levels,
//     this.courses,
//     this.students,
//     this.doctorDepartmentsLevels,
//     this.lectureSchedules,
//   });

//   factory Department.fromJson(Map<String, dynamic> json) {
//     return Department(
//       id: json['id'] as int,
//       departmentName: json['departmentName'] as String,
//       description: json['description'] as String?,
//       isActive: json['isActive'] as bool,
//       // createdAt: DateTime.parse(json['createdAt'] as String),
//       // updatedAt: json['updatedAt'] != null
//       //     ? DateTime.parse(json['updatedAt'] as String)
//       //     : null,
//       levels: json['levels'] != null
//           ? (json['levels'] as List).map((e) => Level.fromJson(e)).toList()
//           : null,
//       courses: json['courses'] != null
//           ? (json['courses'] as List).map((e) => Course.fromJson(e)).toList()
//           : null,
//       students: json['students'] != null
//           ? (json['students'] as List).map((e) => Student.fromJson(e)).toList()
//           : null,
//       doctorDepartmentsLevels: json['doctorDepartmentsLevels'] != null
//           ? (json['doctorDepartmentsLevels'] as List)
//               .map((e) => DoctorDepartmentsLevels.fromJson(e))
//               .toList()
//           : null,
//       lectureSchedules: json['lectureSchedules'] != null
//           ? (json['lectureSchedules'] as List)
//               .map((e) => LectureSchedule.fromJson(e))
//               .toList()
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'departmentName': departmentName,
//       'description': description,
//       'isActive': isActive,
//       // 'createdAt': createdAt.toIso8601String(),
//       // 'updatedAt': updatedAt?.toIso8601String(),
//       'levels': levels?.map((e) => e.toJson()).toList(),
//       'courses': courses?.map((e) => e.toJson()).toList(),
//       'students': students?.map((e) => e.toJson()).toList(),
//       'doctorDepartmentsLevels':
//           doctorDepartmentsLevels?.map((e) => e.toJson()).toList(),
//       'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
