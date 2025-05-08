using API.DTOs;
using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class AttendanceReportService : IAttendanceReportService
    {
        private readonly IAttendanceRepository _attendanceRepository;
        private readonly IStudentRepository _studentRepository;
        private readonly IDepartmentRepository _departmentRepository;
        private readonly ILevelRepository _levelRepository;
        private readonly ILectureScheduleRepository _lectureScheduleRepository;

        public AttendanceReportService(
            IAttendanceRepository attendanceRepository,
            IStudentRepository studentRepository,
            IDepartmentRepository departmentRepository,
            ILevelRepository levelRepository,
            ILectureScheduleRepository lectureScheduleRepository)
        {
            _attendanceRepository = attendanceRepository;
            _studentRepository = studentRepository;
            _departmentRepository = departmentRepository;
            _levelRepository = levelRepository;
            _lectureScheduleRepository = lectureScheduleRepository;
        }

        public async Task<AttendanceReportDto> GetAttendanceByScheduleAsync(int scheduleId)
        {
            var schedule = await _lectureScheduleRepository.GetByIdAsync(scheduleId);
            if (schedule == null)
                return null;

            var attendances = (await _attendanceRepository.GetAttendancesByScheduleAsync(scheduleId)).ToList();
            return GenerateReport(attendances, $"Schedule: {schedule.CourseSubject.Course.CourseName} - {schedule.DayOfWeek}");
        }

        public async Task<AttendanceReportDto> GetAttendanceByDoctorAsync(int doctorId)
        {
            var schedules = (await _lectureScheduleRepository.GetSchedulesByDoctorAsync(doctorId)).ToList();
            var attendances = new List<Attendance>();

            foreach (var schedule in schedules)
            {
                var scheduleAttendances = (await _attendanceRepository.GetAttendancesByScheduleAsync(schedule.Id)).ToList();
                attendances.AddRange(scheduleAttendances);
            }

            return GenerateReport(attendances, $"Doctor ID: {doctorId}");
        }

        public async Task<AttendanceReportDto> GetAttendanceByStudentAsync(int studentId)
        {
            var attendances = (await _attendanceRepository.GetAttendancesByStudentAsync(studentId)).ToList();
            return GenerateReport(attendances, $"Student ID: {studentId}");
        }
        public async Task<AttendanceReportDto> GetAttendancesByDoctorAsync(int studentId)
        {
            var attendances = (await _attendanceRepository.GetAttendancesByDoctorAsync(studentId)).ToList();
            return GenerateReport(attendances, $"Doctor ID: {studentId}");
        }

        public async Task<AttendanceReportDto> GetAttendanceByDepartmentAsync(int departmentId)
        {
            var students = await _studentRepository.GetStudentsByDepartmentAsync(departmentId);
            var attendances = new List<Attendance>();

            foreach (var student in students)
            {
                var studentAttendances = (await _attendanceRepository.GetAttendancesByStudentAsync(student.Id)).ToList();
                attendances.AddRange(studentAttendances);
            }

            return GenerateReport(attendances, $"Department ID: {departmentId}");
        }

        public async Task<AttendanceReportDto> GetAttendanceByLevelAsync(int levelId)
        {
            var students = await _studentRepository.GetStudentsByLevelAsync(levelId);
            var attendances = new List<Attendance>();

            foreach (var student in students)
            {
                var studentAttendances = (await _attendanceRepository.GetAttendancesByStudentAsync(student.Id)).ToList();
                attendances.AddRange(studentAttendances);
            }

            return GenerateReport(attendances, $"Level ID: {levelId}");
        }

        public async Task<AttendanceReportDto> GetAttendanceByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            var attendances = (await _attendanceRepository.GetAttendancesByDateRangeAsync(startDate, endDate)).ToList();
            return GenerateReport(attendances, $"Date Range: {startDate:yyyy-MM-dd} to {endDate:yyyy-MM-dd}");
        }

        private AttendanceReportDto GenerateReport(List<Attendance> attendances, string title)
        {
            var schedule = attendances.FirstOrDefault()?.LectureSchedule;
            if (schedule == null)
            {
                return new AttendanceReportDto
                {
                    ScheduleId = 0,
                    CourseName = "N/A",
                    LevelName = "N/A",
                    DepartmentName = "N/A",
                    LectureDate = DateTime.Now,
                    TotalStudents = 0,
                    PresentStudents = 0,
                    AbsentStudents = 0,
                    AttendancePercentage = 0,
                    StudentAttendances = new List<StudentAttendanceDto>()
                };
            }
            var s = title.Contains("Doctor");
            if(!s)
            {var students = attendances.Select(a => a.Student).Distinct().ToList();
                var studentAttendances = students.Select(student => new StudentAttendanceDto
                {
                    StudentId = student.Id,
                    StudentName = student.User.FullName,
                    StudentNumber = student.User.Username,
                    IsPresent = attendances.Any(a => a.StudentId == student.Id && a.Status),
                    AttendanceTime = attendances.FirstOrDefault(a => a.StudentId == student.Id)?.AttendanceDate
                }).ToList();
            return new AttendanceReportDto
            {
                ScheduleId = schedule.Id,
                CourseName = schedule.CourseSubject.Course.CourseName,
                LevelName = schedule.Level.LevelName,
                DepartmentName = schedule.Department.DepartmentName,
                LectureDate = DateTime.Today.Add(schedule.StartTime), // Convert TimeSpan to DateTime
                TotalStudents = students.Count,
                PresentStudents = attendances.Count(a => a.Status),
                AbsentStudents = students.Count - attendances.Count(a => a.Status),
                AttendancePercentage = students.Count > 0 ? (double)attendances.Count(a => a.Status) / students.Count * 100 : 0,
                StudentAttendances = studentAttendances
            };
            }
            else
            {
                
                    var students = attendances.Select(a => a.Student).Distinct().ToList();
                    return new AttendanceReportDto
                    {
                        ScheduleId = schedule.Id,
                        CourseName = schedule.CourseSubject.Course.CourseName,
                        //LevelName = null,
                        LevelName = schedule.Level.LevelName,
                        DepartmentName = schedule.Department.DepartmentName,
                        LectureDate = DateTime.Today.Add(schedule.StartTime), // Convert TimeSpan to DateTime
                        TotalStudents = attendances.Count(s => s.Student != null),
                        PresentStudents = attendances.Count(a => a.Status),
                        AbsentStudents = attendances.Count(s => s.Student != null) - attendances.Count(a => a.Status),
                        AttendancePercentage = attendances.Count(s => s.Student != null) > 0 ? (double)attendances.Count(a => a.Status) / attendances.Count(s => s.Student != null) * 100 : 0,
                        StudentAttendances = students.Select(student => new StudentAttendanceDto
                        {
                            StudentId = student.Id,
                            StudentName = student.User.FullName,
                            StudentNumber = student.User.Username,
                            IsPresent = attendances.Any(a => a.StudentId == student.Id && a.Status),
                            AttendanceTime = attendances.FirstOrDefault(a => a.StudentId == student.Id)?.AttendanceDate
                        }).ToList(),

                    };
            }

        }
    }
}