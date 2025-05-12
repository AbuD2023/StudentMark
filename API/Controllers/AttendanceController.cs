using API.DTOs;
using API.Entities;
using API.Extensions;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class AttendanceController : ControllerBase
    {
        private readonly IAttendanceService _attendanceService;
        private readonly IQRCodeService _qrCodeService;
        private readonly IStudentService _studentService;
        private readonly ILectureScheduleService _scheduleService;
        private readonly ICourseSubjectService _courseSubjectService;
        private readonly IDoctorDepartmentsLevelsService _doctorService;

        public AttendanceController(
            IAttendanceService attendanceService,
            IQRCodeService qrCodeService,
            IStudentService studentService,
            ILectureScheduleService scheduleService,
            ICourseSubjectService courseSubjectService,
            IDoctorDepartmentsLevelsService doctorService)
        {
            _attendanceService = attendanceService;
            _qrCodeService = qrCodeService;
            _studentService = studentService;
            _scheduleService = scheduleService;
            _courseSubjectService = courseSubjectService;
            _doctorService = doctorService;
        }

        [HttpPost("mark")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> MarkAttendance([FromBody] AttendanceMarkDto attendanceDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null)
            {
                return BadRequest(new { message = "Student not found" });
            }

            // التحقق من صحة رمز QR
            var qrCode = await _qrCodeService.GetQRCodeByValueAsync(attendanceDto.QRCodeValue);
            if (qrCode == null)
            {
                return BadRequest(new { message = "Invalid QR code" });
            }

            if (!qrCode.IsActive)
            {
                return BadRequest(new { message = "QR code is not active" });
            }

            if (qrCode.ExpiresAt < DateTime.Now)
            {
                return BadRequest(new { message = "QR code has expired" });
            }

            // التحقق من أن الطالب ينتمي لنفس المستوى والقسم للمحاضرة
            var schedule = await _scheduleService.GetByIdAsync(qrCode.ScheduleId);
            if (schedule == null)
            {
                return BadRequest(new { message = "Schedule not found" });
            }

            if (schedule.LevelId != student.LevelId || schedule.DepartmentId != student.DepartmentId)
            {
                return BadRequest(new { message = "You are not enrolled in this lecture" });
            }

            // التحقق من عدم تسجيل الحضور مسبقاً
            var isUnique = await _attendanceService.IsAttendanceUniqueAsync(student.Id, schedule.Id, DateTime.Now);
            if (!isUnique)
            {
                return BadRequest(new { message = "Attendance already marked" });
            }

            // تسجيل الحضور
            var attendance = new Attendance
            {
                StudentId = student.Id,
                ScheduleId = schedule.Id,
                AttendanceDate = DateTime.Now,
                Status = true
            };

            await _attendanceService.AddAsync(attendance);
            return Ok(new { message = "Attendance marked successfully" });
        }

        [HttpGet("student/{studentId}/status")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetAttendanceStatus(int studentId)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null || student.Id != studentId)
            {
                return Forbid();
            }

            var attendances = await _attendanceService.GetAttendancesByStudentAsync(studentId);
            var today = DateTime.Today;
            var todayAttendances = attendances.Where(a => a.AttendanceDate.Date == today);

            return Ok(new
            {
                TotalLectures = todayAttendances.Count(),
                PresentLectures = todayAttendances.Count(a => a.Status),
                AbsentLectures = todayAttendances.Count(a => !a.Status),
                AttendancePercentage = todayAttendances.Any() ?
                    (double)todayAttendances.Count(a => a.Status) / todayAttendances.Count() * 100 : 0
            });
        }

        [HttpGet("student/{studentId}")]
        //[Authorize(Roles = "Student")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GetStudentAttendances(int studentId)
        {
            //var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(studentId);
            if (student == null || student.Id != studentId)
            {
                return Forbid();
            }

            var attendances = await _attendanceService.GetAttendancesByStudentAsync(studentId);
            return Ok(attendances.OrderByDescending(a => a.AttendanceDate));
        }

        [HttpGet("student/{studentId}/course/{courseId}")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetAttendanceByCourse(int studentId, int courseId)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null || student.Id != studentId)
            {
                return Forbid();
            }

            var course = await _courseSubjectService.GetByIdAsync(courseId);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            var attendances = await _attendanceService.GetStudentAttendanceReportAsync(
                studentId,
                DateTime.Now.AddMonths(-3), // آخر 3 أشهر
                DateTime.Now);

            var courseAttendances = attendances
                .Where(a => a.LectureSchedule.CourseSubject.CourseId == courseId)
                .GroupBy(a => a.LectureSchedule.CourseSubjectId)
                .Select(g => new
                {
                    CourseSubjectId = g.Key,
                    CourseSubjectName = g.First().LectureSchedule.CourseSubject.Subject.SubjectName,
                    TotalLectures = g.Count(),
                    PresentLectures = g.Count(a => a.Status),
                    AbsentLectures = g.Count(a => !a.Status),
                    AttendancePercentage = g.Count() > 0 ?
                        (double)g.Count(a => a.Status) / g.Count() * 100 : 0
                });

            return Ok(courseAttendances);
        }

        [HttpGet("student/{studentId}/doctor/{doctorId}")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetAttendanceByDoctor(int studentId, int doctorId)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null || student.Id != studentId)
            {
                return Forbid();
            }

            var doctor = await _doctorService.GetByDoctorAsync(doctorId);
            if (doctor == null || !doctor.Any())
            {
                return NotFound(new { message = "Doctor not found" });
            }

            var attendances = await _attendanceService.GetStudentAttendanceReportAsync(
                studentId,
                DateTime.Now.AddMonths(-3), // آخر 3 أشهر
                DateTime.Now);

            var doctorAttendances = attendances
                .Where(a => a.LectureSchedule.DoctorId == doctorId)
                .GroupBy(a => a.LectureSchedule.CourseSubjectId)
                .Select(g => new
                {
                    CourseSubjectId = g.Key,
                    CourseSubjectName = g.First().LectureSchedule.CourseSubject.Subject.SubjectName,
                    TotalLectures = g.Count(),
                    PresentLectures = g.Count(a => a.Status),
                    AbsentLectures = g.Count(a => !a.Status),
                    AttendancePercentage = g.Count() > 0 ?
                        (double)g.Count(a => a.Status) / g.Count() * 100 : 0
                });

            return Ok(doctorAttendances);
        }

        [HttpGet("student/{studentId}/report")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetAttendanceReport(int studentId, [FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null || student.Id != studentId)
            {
                return Forbid();
            }

            var start = startDate ?? DateTime.Now.AddMonths(-3);
            var end = endDate ?? DateTime.Now;

            var attendances = await _attendanceService.GetStudentAttendanceReportAsync(studentId, start, end);

            var report = new
            {
                TotalLectures = attendances.Count(),
                PresentLectures = attendances.Count(a => a.Status),
                AbsentLectures = attendances.Count(a => !a.Status),
                AttendancePercentage = attendances.Any() ?
                    (double)attendances.Count(a => a.Status) / attendances.Count() * 100 : 0,
                CourseDetails = attendances
                    .GroupBy(a => a.LectureSchedule.CourseSubjectId)
                    .Select(g => new
                    {
                        CourseSubjectId = g.Key,
                        CourseSubjectName = g.First().LectureSchedule.CourseSubject.Subject.SubjectName,
                        TotalLectures = g.Count(),
                        PresentLectures = g.Count(a => a.Status),
                        AbsentLectures = g.Count(a => !a.Status),
                        AttendancePercentage = g.Count() > 0 ?
                            (double)g.Count(a => a.Status) / g.Count() * 100 : 0
                    }),
                DoctorDetails = attendances
                    .GroupBy(a => a.LectureSchedule.DoctorId)
                    .Select(g => new
                    {
                        DoctorId = g.Key,
                        DoctorName = g.First().LectureSchedule.Doctor.FullName,
                        TotalLectures = g.Count(),
                        PresentLectures = g.Count(a => a.Status),
                        AbsentLectures = g.Count(a => !a.Status),
                        AttendancePercentage = g.Count() > 0 ?
                            (double)g.Count(a => a.Status) / g.Count() * 100 : 0
                    })
            };

            return Ok(report);
        }

        [HttpGet("today")]
        [Authorize(Roles = "Student")]
        public async Task<IActionResult> GetAttendancesByTodayAsync()
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithStudentIdAsync(userId);
            if (student == null )
            {
                return Forbid();
            }

            var attendances = await _attendanceService.GetAttendancesByTodayAsync();
            return Ok(attendances.OrderByDescending(a => a.AttendanceDate));
        }
    }
}