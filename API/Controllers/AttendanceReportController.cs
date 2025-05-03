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
    public class AttendanceReportController : ControllerBase
    {
        private readonly IAttendanceReportService _attendanceReportService;
        private readonly IDoctorDepartmentsLevelsService _doctorService;

        public AttendanceReportController(
            IAttendanceReportService attendanceReportService,
            IDoctorDepartmentsLevelsService doctorService)
        {
            _attendanceReportService = attendanceReportService;
            _doctorService = doctorService;
        }

        [HttpGet("schedule/{scheduleId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportBySchedule(int scheduleId)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return Forbid();
                }
            }

            var report = await _attendanceReportService.GetAttendanceByScheduleAsync(scheduleId);
            return Ok(report);
        }

        [HttpGet("doctor/{doctorId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportsByDoctor(int doctorId)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                if (doctorId != userId)
                {
                    return Forbid();
                }
            }

            var reports = await _attendanceReportService.GetAttendanceByDoctorAsync(doctorId);
            return Ok(reports);
        }

        [HttpGet("course/{courseId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportsByCourse(int courseId)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return Forbid();
                }
            }

            var reports = await _attendanceReportService.GetAttendanceByScheduleAsync(courseId);
            return Ok(reports);
        }

        [HttpGet("level/{levelId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportsByLevel(int levelId)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return Forbid();
                }
            }

            var reports = await _attendanceReportService.GetAttendanceByLevelAsync(levelId);
            return Ok(reports);
        }

        [HttpGet("department/{departmentId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportsByDepartment(int departmentId)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return Forbid();
                }
            }

            var reports = await _attendanceReportService.GetAttendanceByDepartmentAsync(departmentId);
            return Ok(reports);
        }

        [HttpGet("date-range")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetAttendanceReportsByDateRange([FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
        {
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any())
                {
                    return Forbid();
                }
            }

            var reports = await _attendanceReportService.GetAttendanceByDateRangeAsync(startDate, endDate);
            return Ok(reports);
        }

        [HttpGet("student/{studentId}")]
        public async Task<ActionResult<AttendanceReportDto>> GetAttendanceByStudent(int studentId)
        {
            var report = await _attendanceReportService.GetAttendanceByStudentAsync(studentId);
            return Ok(report);
        }

        // [HttpGet($"department/{{departmentId}}")]
        // public async Task<ActionResult<AttendanceReportDto>> GetAttendanceByDepartment(int departmentId)
        // {
        //     var report = await _attendanceReportService.GetAttendanceByDepartmentAsync(departmentId);
        //     return Ok(report);
        // }

        // [HttpGet($"level/{{levelId}}")]
        // public async Task<ActionResult<AttendanceReportDto>> GetAttendanceByLevel(int levelId)
        // {
        //     var report = await _attendanceReportService.GetAttendanceByLevelAsync(levelId);
        //     return Ok(report);
        // }

        // [HttpGet($"date-range")]
        // public async Task<ActionResult<AttendanceReportDto>> GetAttendanceByDateRange(
        //     [FromQuery] DateTime startDate,
        //     [FromQuery] DateTime endDate)
        // {
        //     var report = await _attendanceReportService.GetAttendanceByDateRangeAsync(startDate, endDate);
        //     return Ok(report);
        // }
    }
}