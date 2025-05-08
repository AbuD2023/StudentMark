class AttendanceReportForDoctor {
  int? scheduleId;
  String? courseName;
  String? levelName;
  String? departmentName;
  String? lectureDate;
  int? totalStudents;
  int? presentStudents;
  int? absentStudents;
  double? attendancePercentage;
  List<StudentAttendances>? studentAttendances;

  AttendanceReportForDoctor(
      {this.scheduleId,
      this.courseName,
      this.levelName,
      this.departmentName,
      this.lectureDate,
      this.totalStudents,
      this.presentStudents,
      this.absentStudents,
      this.attendancePercentage,
      this.studentAttendances});

  AttendanceReportForDoctor.fromJson(Map<String, dynamic> json) {
    scheduleId = json['scheduleId'];
    courseName = json['courseName'];
    levelName = json['levelName'];
    departmentName = json['departmentName'];
    lectureDate = json['lectureDate'];
    totalStudents = json['totalStudents'];
    presentStudents = json['presentStudents'];
    absentStudents = json['absentStudents'];
    attendancePercentage = json['attendancePercentage'];
    if (json['studentAttendances'] != null) {
      studentAttendances = <StudentAttendances>[];
      json['studentAttendances'].forEach((v) {
        studentAttendances!.add(new StudentAttendances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scheduleId'] = this.scheduleId;
    data['courseName'] = this.courseName;
    data['levelName'] = this.levelName;
    data['departmentName'] = this.departmentName;
    data['lectureDate'] = this.lectureDate;
    data['totalStudents'] = this.totalStudents;
    data['presentStudents'] = this.presentStudents;
    data['absentStudents'] = this.absentStudents;
    data['attendancePercentage'] = this.attendancePercentage;
    if (this.studentAttendances != null) {
      data['studentAttendances'] =
          this.studentAttendances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentAttendances {
  int? studentId;
  String? studentName;
  String? studentNumber;
  bool? isPresent;
  String? attendanceTime;

  StudentAttendances(
      {this.studentId,
      this.studentName,
      this.studentNumber,
      this.isPresent,
      this.attendanceTime});

  StudentAttendances.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentNumber = json['studentNumber'];
    isPresent = json['isPresent'];
    attendanceTime = json['attendanceTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    data['studentNumber'] = this.studentNumber;
    data['isPresent'] = this.isPresent;
    data['attendanceTime'] = this.attendanceTime;
    return data;
  }
}
