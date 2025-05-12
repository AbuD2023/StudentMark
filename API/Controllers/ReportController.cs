using API.DTOs;
using API.Extensions;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ReportController : ControllerBase
    {
        private readonly IAttendanceService _attendanceService;
        private readonly ILectureScheduleService _scheduleService;
        private readonly IStudentService _studentService;
        private readonly IDoctorDepartmentsLevelsService _doctorService;
        private readonly IUserService _userService;

        public ReportController(
            IAttendanceService attendanceService,
            ILectureScheduleService scheduleService,
            IStudentService studentService,
            IDoctorDepartmentsLevelsService doctorService,
            IUserService userService)
        {
            _attendanceService = attendanceService;
            _scheduleService = scheduleService;
            _studentService = studentService;
            _doctorService = doctorService;
            _userService = userService;

        }

        [HttpPost("attendance")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GenerateAttendanceReport([FromBody] ReportDto reportDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var attendances = await _attendanceService.GetAttendancesByDateRangeAsync(reportDto.StartDate, reportDto.EndDate);

            // Apply filters
            if (reportDto.DepartmentId.HasValue)
            {
                attendances = attendances.Where(a => a.LectureSchedule.DepartmentId == reportDto.DepartmentId.Value);
            }
            if (reportDto.LevelId.HasValue)
            {
                attendances = attendances.Where(a => a.LectureSchedule.LevelId == reportDto.LevelId.Value);
            }
            if (reportDto.DoctorId.HasValue)
            {
                attendances = attendances.Where(a => a.LectureSchedule.DoctorId == reportDto.DoctorId.Value);
            }
            if (reportDto.StudentId.HasValue)
            {
                attendances = attendances.Where(a => a.StudentId == reportDto.StudentId.Value);
            }
            if (reportDto.CourseSubjectId.HasValue)
            {
                attendances = attendances.Where(a => a.LectureSchedule.CourseSubjectId == reportDto.CourseSubjectId.Value);
            }

            return Ok(attendances);
        }

        [HttpPost("student-attendance")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GenerateStudentAttendanceReport([FromBody] ReportDto reportDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // If student role, only allow viewing their own report
            if (User.IsInRole("Student"))
            {
                var userId = HttpContext.GetUserId();
                var student = await _studentService.GetStudentWithStudentIdAsync(userId);
                if (student == null)
                {
                    return NotFound(new { message = "Student not found" });
                }
                reportDto.StudentId = student.Id;
            }

            var report = await _attendanceService.GetStudentAttendanceReportAsync(
                reportDto.StudentId.Value,
                reportDto.StartDate,
                reportDto.EndDate);

            return Ok(report);
        }

        [HttpPost("doctor-schedule")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GenerateDoctorScheduleReport([FromBody] ReportDto reportDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // If doctor role, only allow viewing their own report
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return NotFound(new { message = "Doctor not found" });
                }
                reportDto.DoctorId = userId;
            }

            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(reportDto.DoctorId.Value);

            // Apply filters
            if (reportDto.DepartmentId.HasValue)
            {
                schedules = schedules.Where(s => s.DepartmentId == reportDto.DepartmentId.Value);
            }
            if (reportDto.LevelId.HasValue)
            {
                schedules = schedules.Where(s => s.LevelId == reportDto.LevelId.Value);
            }
            if (reportDto.CourseSubjectId.HasValue)
            {
                schedules = schedules.Where(s => s.CourseSubjectId == reportDto.CourseSubjectId.Value);
            }

            return Ok(schedules);
        }

        [HttpPost("department-statistics")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GenerateDepartmentStatistics([FromBody] ReportDto reportDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var statistics = new
            {
                TotalStudents = await _studentService.GetStudentsByDepartmentAsync(reportDto.DepartmentId.Value),
                TotalDoctors = await _doctorService.GetByDepartmentAsync(reportDto.DepartmentId.Value),
                TotalSchedules = await _scheduleService.GetSchedulesByDepartmentAsync(reportDto.DepartmentId.Value),
                AttendanceRate = await CalculateAttendanceRate(reportDto.DepartmentId.Value, reportDto.StartDate, reportDto.EndDate)
            };

            return Ok(statistics);
        }

        [HttpPost("level-statistics")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GenerateLevelStatistics([FromBody] ReportDto reportDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var statistics = new
            {
                TotalStudents = await _studentService.GetStudentsByLevelAsync(reportDto.LevelId.Value),
                TotalSchedules = await _scheduleService.GetSchedulesByLevelAsync(reportDto.LevelId.Value),
                AttendanceRate = await CalculateAttendanceRate(null, reportDto.StartDate, reportDto.EndDate, reportDto.LevelId)
            };

            return Ok(statistics);
        }

        private async Task<double> CalculateAttendanceRate(int? departmentId, DateTime startDate, DateTime endDate, int? levelId = null)
        {
            var attendances = await _attendanceService.GetAttendancesByDateRangeAsync(startDate, endDate);
            var schedules = await _scheduleService.GetAllAsync();

            // Apply filters
            if (departmentId.HasValue)
            {
                schedules = schedules.Where(s => s.DepartmentId == departmentId.Value);
            }
            if (levelId.HasValue)
            {
                schedules = schedules.Where(s => s.LevelId == levelId.Value);
            }

            var totalSchedules = schedules.Count();
            if (totalSchedules == 0)
            {
                return 0;
            }

            var totalAttendances = attendances.Count(a => schedules.Any(s => s.Id == a.ScheduleId));
            return (double)totalAttendances / totalSchedules * 100;
        }
    }
}