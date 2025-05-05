import '../../features/departments/domain/models/department_model.dart';
import 'course_subject.dart';
import 'lecture_schedule.dart';

class Course {
  final int id;
  final String courseName;
  final String? description;
  final int departmentId;
  final bool isActive;

  // Navigation properties
  final Department? department;
  final List<CourseSubject>? courseSubjects;
  final List<LectureSchedule>? lectureSchedules;

  Course({
    required this.id,
    required this.courseName,
    this.description,
    required this.departmentId,
    required this.isActive,
    this.department,
    this.courseSubjects,
    this.lectureSchedules,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      courseName: json['courseName'] as String,
      description: json['description'] as String?,
      departmentId: json['departmentId'] as int,
      isActive: json['isActive'] as bool,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      courseSubjects: json['courseSubjects'] != null
          ? (json['courseSubjects'] as List)
              .map((e) => CourseSubject.fromJson(e))
              .toList()
          : null,
      lectureSchedules: json['lectureSchedules'] != null
          ? (json['lectureSchedules'] as List)
              .map((e) => LectureSchedule.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'description': description,
      'departmentId': departmentId,
      'isActive': isActive,
      'department': department?.toJson(),
      'courseSubjects': courseSubjects?.map((e) => e.toJson()).toList(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }

  Course copyWith({
    int? id,
    String? courseName,
    String? description,
    int? departmentId,
    bool? isActive,
    Department? department,
    List<CourseSubject>? courseSubjects,
    List<LectureSchedule>? lectureSchedules,
  }) {
    return Course(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      description: description ?? this.description,
      departmentId: departmentId ?? this.departmentId,
      isActive: isActive ?? this.isActive,
      department: department ?? this.department,
      courseSubjects: courseSubjects ?? this.courseSubjects,
      lectureSchedules: lectureSchedules ?? this.lectureSchedules,
    );
  }
}
