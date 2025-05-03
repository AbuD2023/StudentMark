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
    public class LectureScheduleController : ControllerBase
    {
        private readonly ILectureScheduleService _scheduleService;
        private readonly IDoctorDepartmentsLevelsService _doctorService;
        private readonly IStudentService _studentService;

        public LectureScheduleController(
            ILectureScheduleService scheduleService,
            IDoctorDepartmentsLevelsService doctorService,
            IStudentService studentService)
        {
            _scheduleService = scheduleService;
            _doctorService = doctorService;
            _studentService = studentService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetSchedules()
        {
            var schedules = await _scheduleService.GetAllAsync();
            return Ok(schedules);
        }

        [HttpGet("active")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetActiveSchedules()
        {
            var schedules = await _scheduleService.GetActiveSchedulesAsync();
            return Ok(schedules);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<LectureSchedule>> GetSchedule(int id)
        {
            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }
            return Ok(schedule);
        }

        [HttpGet("doctor/{doctorId}")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetSchedulesByDoctor(int doctorId)
        {
            // Check if the requesting user is the doctor or has appropriate role
            var userId = HttpContext.GetUserId();
            if (userId != doctorId && !User.IsInRole("Admin") && !User.IsInRole("Coordinator"))
            {
                return Forbid();
            }

            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(doctorId);
            return Ok(schedules);
        }

        [HttpGet("course-subject/{courseSubjectId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetSchedulesByCourseSubject(int courseSubjectId)
        {
            var schedules = await _scheduleService.GetSchedulesByCourseSubjectAsync(courseSubjectId);
            return Ok(schedules);
        }

        [HttpGet("department/{departmentId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetSchedulesByDepartment(int departmentId)
        {
            var schedules = await _scheduleService.GetSchedulesByDepartmentAsync(departmentId);
            return Ok(schedules);
        }

        [HttpGet("level/{levelId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetSchedulesByLevel(int levelId)
        {
            var schedules = await _scheduleService.GetSchedulesByLevelAsync(levelId);
            return Ok(schedules);
        }

        [HttpGet("{id}/qrcodes")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<ActionResult<IEnumerable<QRCode>>> GetScheduleQRCodes(int id)
        {
            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }

            // Check if the requesting user is the doctor or has appropriate role
            var userId = HttpContext.GetUserId();
            if (userId != schedule.DoctorId && !User.IsInRole("Admin") && !User.IsInRole("Coordinator"))
            {
                return Forbid();
            }

            var qrCodes = await _scheduleService.GetScheduleQRCodesAsync(id);
            return Ok(qrCodes);
        }

        [HttpGet("{id}/attendances")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<ActionResult<IEnumerable<Attendance>>> GetScheduleAttendances(int id)
        {
            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }

            // Check if the requesting user is the doctor or has appropriate role
            var userId = HttpContext.GetUserId();
            if (userId != schedule.DoctorId && !User.IsInRole("Admin") && !User.IsInRole("Coordinator"))
            {
                return Forbid();
            }

            var attendances = await _scheduleService.GetScheduleAttendancesAsync(id);
            return Ok(attendances);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<LectureSchedule>> CreateSchedule([FromBody] LectureScheduleDto scheduleDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if time slot is available for the doctor
            if (!await _scheduleService.IsTimeSlotAvailableAsync(
                scheduleDto.DoctorId,
                scheduleDto.DayOfWeek,
                scheduleDto.StartTime,
                scheduleDto.EndTime))
            {
                return BadRequest(new { message = "Time slot is not available for the doctor" });
            }

            var schedule = new LectureSchedule
            {
                CourseSubjectId = scheduleDto.CourseSubjectId,
                DoctorId = scheduleDto.DoctorId,
                DepartmentId = scheduleDto.DepartmentId,
                LevelId = scheduleDto.LevelId,
                DayOfWeek = scheduleDto.DayOfWeek,
                StartTime = scheduleDto.StartTime,
                EndTime = scheduleDto.EndTime,
                IsActive = true
            };

            await _scheduleService.AddAsync(schedule);
            return CreatedAtAction(nameof(GetSchedule), new { id = schedule.Id }, schedule);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateSchedule(int id, [FromBody] LectureScheduleDto scheduleDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }

            // Check if new time slot is available for the doctor
            if (schedule.DayOfWeek != scheduleDto.DayOfWeek ||
                schedule.StartTime != scheduleDto.StartTime ||
                schedule.EndTime != scheduleDto.EndTime)
            {
                if (!await _scheduleService.IsTimeSlotAvailableAsync(
                    scheduleDto.DoctorId,
                    scheduleDto.DayOfWeek,
                    scheduleDto.StartTime,
                    scheduleDto.EndTime))
                {
                    return BadRequest(new { message = "Time slot is not available for the doctor" });
                }
            }

            schedule.CourseSubjectId = scheduleDto.CourseSubjectId;
            schedule.DoctorId = scheduleDto.DoctorId;
            schedule.DepartmentId = scheduleDto.DepartmentId;
            schedule.LevelId = scheduleDto.LevelId;
            schedule.DayOfWeek = scheduleDto.DayOfWeek;
            schedule.StartTime = scheduleDto.StartTime;
            schedule.EndTime = scheduleDto.EndTime;

            await _scheduleService.UpdateAsync(schedule);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleScheduleStatus(int id)
        {
            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }

            schedule.IsActive = !schedule.IsActive;
            await _scheduleService.UpdateAsync(schedule);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSchedule(int id)
        {
            var schedule = await _scheduleService.GetByIdAsync(id);
            if (schedule == null)
            {
                return NotFound(new { message = "Schedule not found" });
            }

            await _scheduleService.DeleteAsync(id);
            return NoContent();
        }

        [HttpGet("doctor/{doctorId}/today")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetTodaySchedules(int doctorId)
        {
            // التحقق من أن الطبيب يطلب جدوله الخاص
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any() || doctorAssignments.First().DoctorId != doctorId)
                {
                    return Forbid();
                }
            }

            var today = DateTime.Today;
            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(doctorId);
            var todaySchedules = schedules.Where(s => s.DayOfWeek == today.DayOfWeek)
                                       .OrderBy(s => s.StartTime);

            return Ok(todaySchedules);
        }

        [HttpGet("doctor/{doctorId}/week")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetWeekSchedules(int doctorId, [FromQuery] DateTime? startDate)
        {
            // التحقق من أن الطبيب يطلب جدوله الخاص
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any() || doctorAssignments.First().DoctorId != doctorId)
                {
                    return Forbid();
                }
            }

            var start = startDate ?? DateTime.Today;
            var end = start.AddDays(7);
            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(doctorId);

            var weekSchedules = schedules.OrderBy(s => s.DayOfWeek)
                                      .ThenBy(s => s.StartTime);

            return Ok(weekSchedules);
        }

        [HttpGet("doctor/{doctorId}/month")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetMonthSchedules(int doctorId, [FromQuery] DateTime? startDate)
        {
            // التحقق من أن الطبيب يطلب جدوله الخاص
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any() || doctorAssignments.First().DoctorId != doctorId)
                {
                    return Forbid();
                }
            }

            var start = startDate ?? new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1);
            var end = start.AddMonths(1);
            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(doctorId);

            var monthSchedules = schedules.OrderBy(s => s.DayOfWeek)
                                      .ThenBy(s => s.StartTime);

            return Ok(monthSchedules);
        }

        [HttpGet("doctor/{doctorId}/filter")]
        [Authorize(Roles = "Admin,Coordinator,Doctor")]
        public async Task<IActionResult> GetFilteredSchedules(
            int doctorId,
            [FromQuery] int? departmentId,
            [FromQuery] int? levelId,
            [FromQuery] int? courseSubjectId,
            [FromQuery] DayOfWeek? dayOfWeek)
        {
            // التحقق من أن الطبيب يطلب جدوله الخاص
            if (User.IsInRole("Doctor"))
            {
                var userId = HttpContext.GetUserId();
                var doctorAssignments = await _doctorService.GetByDoctorAsync(userId);
                if (!doctorAssignments.Any() || doctorAssignments.First().DoctorId != doctorId)
                {
                    return Forbid();
                }
            }

            var schedules = await _scheduleService.GetSchedulesByDoctorAsync(doctorId);

            // تطبيق التصفية
            if (departmentId.HasValue)
            {
                schedules = schedules.Where(s => s.DepartmentId == departmentId.Value);
            }
            if (levelId.HasValue)
            {
                schedules = schedules.Where(s => s.LevelId == levelId.Value);
            }
            if (courseSubjectId.HasValue)
            {
                schedules = schedules.Where(s => s.CourseSubjectId == courseSubjectId.Value);
            }
            if (dayOfWeek.HasValue)
            {
                schedules = schedules.Where(s => s.DayOfWeek == dayOfWeek.Value);
            }

            var filteredSchedules = schedules.OrderBy(s => s.DayOfWeek)
                                          .ThenBy(s => s.StartTime);

            return Ok(filteredSchedules);
        }

        [HttpGet("level/{levelId}/today")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GetTodaySchedulesByLevel(int levelId)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithUserAsync(userId);

            if (student == null || student.LevelId != levelId)
            {
                return Forbid();
            }

            var today = DateTime.Today;
            var schedules = await _scheduleService.GetSchedulesByLevelAsync(levelId);
            var todaySchedules = schedules.Where(s => s.DayOfWeek == today.DayOfWeek && s.IsActive)
                                        .OrderBy(s => s.StartTime);

            return Ok(todaySchedules);
        }

        [HttpGet("level/{levelId}/week")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GetWeekSchedulesByLevel(int levelId, [FromQuery] DateTime? startDate)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithUserAsync(userId);

            if (student == null || student.LevelId != levelId)
            {
                return Forbid();
            }

            var start = startDate ?? DateTime.Today;
            var end = start.AddDays(7);
            var schedules = await _scheduleService.GetSchedulesByLevelAsync(levelId);
            var weekSchedules = schedules.Where(s => s.IsActive)
                                       .OrderBy(s => s.DayOfWeek)
                                       .ThenBy(s => s.StartTime);

            return Ok(weekSchedules);
        }

        [HttpGet("level/{levelId}/month")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GetMonthSchedulesByLevel(int levelId, [FromQuery] DateTime? startDate)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithUserAsync(userId);

            if (student == null || student.LevelId != levelId)
            {
                return Forbid();
            }

            var start = startDate ?? DateTime.Today;
            var end = start.AddMonths(1);
            var schedules = await _scheduleService.GetSchedulesByLevelAsync(levelId);
            var monthSchedules = schedules.Where(s => s.IsActive)
                                        .OrderBy(s => s.DayOfWeek)
                                        .ThenBy(s => s.StartTime);

            return Ok(monthSchedules);
        }

        [HttpGet("level/{levelId}/filter")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<IActionResult> GetFilteredSchedulesByLevel(
            int levelId,
            [FromQuery] int? departmentId,
            [FromQuery] int? courseSubjectId,
            [FromQuery] DayOfWeek? dayOfWeek)
        {
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithUserAsync(userId);

            if (student == null || student.LevelId != levelId)
            {
                return Forbid();
            }

            var schedules = await _scheduleService.GetSchedulesByLevelAsync(levelId);
            var filteredSchedules = schedules.Where(s => s.IsActive);

            if (departmentId.HasValue)
            {
                filteredSchedules = filteredSchedules.Where(s => s.DepartmentId == departmentId);
            }

            if (courseSubjectId.HasValue)
            {
                filteredSchedules = filteredSchedules.Where(s => s.CourseSubjectId == courseSubjectId);
            }

            if (dayOfWeek.HasValue)
            {
                filteredSchedules = filteredSchedules.Where(s => s.DayOfWeek == dayOfWeek);
            }

            return Ok(filteredSchedules.OrderBy(s => s.DayOfWeek).ThenBy(s => s.StartTime));
        }
    }
}