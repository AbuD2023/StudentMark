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
    public class StudentController : ControllerBase
    {
        private readonly IStudentService _studentService;

        public StudentController(IStudentService studentService)
        {
            _studentService = studentService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudents()
        {
            var students = await _studentService.GetAllAsync();
            return Ok(students);
        }

        [HttpGet("active")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<Student>>> GetActiveStudents()
        {
            var students = await _studentService.GetActiveStudentsAsync();
            return Ok(students);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Student>> GetStudent(int id)
        {
            var student = await _studentService.GetByIdAsync(id);
            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }
            return Ok(student);
        }

        [HttpGet("{id}/with-user")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Student>> GetStudentWithUser(int id)
        {
            var student = await _studentService.GetStudentWithUserAsync(id);
            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }
            return Ok(student);
        }

        [HttpGet("department/{departmentId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudentsByDepartment(int departmentId)
        {
            var students = await _studentService.GetStudentsByDepartmentAsync(departmentId);
            return Ok(students);
        }

        [HttpGet("level/{levelId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<Student>>> GetStudentsByLevel(int levelId)
        {
            var students = await _studentService.GetStudentsByLevelAsync(levelId);
            return Ok(students);
        }

        [HttpGet("{id}/attendances")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<Attendance>>> GetStudentAttendances(int id)
        {
            var attendances = await _studentService.GetStudentAttendancesAsync(id);
            return Ok(attendances);
        }

        [HttpGet("{id}/schedules")]
        [Authorize(Roles = "Admin,Coordinator,Student")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetStudentSchedules(int id)
        {
            // Check if the requesting user is the student or has appropriate role
            var userId = HttpContext.GetUserId();
            var student = await _studentService.GetStudentWithUserAsync(id);

            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }

            if (student.UserId != userId && !User.IsInRole("Admin") && !User.IsInRole("Coordinator"))
            {
                return Forbid();
            }

            var schedules = await _studentService.GetStudentSchedulesAsync(id);
            return Ok(schedules);
        }

        [HttpPost]
        [Authorize(Roles = "Admin")]
        //[AllowAnonymous]
        public async Task<ActionResult<Student>> CreateStudent([FromBody] StudentDto studentDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if enrollment year is valid
            if (!await _studentService.IsEnrollmentYearValidAsync(studentDto.EnrollmentYear))
            {
                return BadRequest(new { message = "Invalid enrollment year" });
            }

            var student = new Student
            {
                Id = 0,
                UserId = studentDto.UserId,
                DepartmentId = studentDto.DepartmentId,
                LevelId = studentDto.LevelId,
                EnrollmentYear = studentDto.EnrollmentYear,
                IsActive = true
            };

            await _studentService.AddRangeAsync([student]);
            return CreatedAtAction(nameof(GetStudent), new { id = student.Id }, student);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateStudent(int id, [FromBody] StudentDto studentDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var student = await _studentService.GetByIdAsync(id);
            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }

            // Check if enrollment year is valid
            if (!await _studentService.IsEnrollmentYearValidAsync(studentDto.EnrollmentYear))
            {
                return BadRequest(new { message = "Invalid enrollment year" });
            }

            student.UserId = studentDto.UserId;
            student.DepartmentId = studentDto.DepartmentId;
            student.LevelId = studentDto.LevelId;
            student.EnrollmentYear = studentDto.EnrollmentYear;

            await _studentService.UpdateAsync(student);
            return Ok(student);
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleStudentStatus(int id)
        {
            var student = await _studentService.GetByIdAsync(id);
            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }

            student.IsActive = !student.IsActive;
            await _studentService.UpdateAsync(student);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteStudent(int id)
        {
            var student = await _studentService.GetByIdAsync(id);
            if (student == null)
            {
                return NotFound(new { message = "Student not found" });
            }

            await _studentService.DeleteAsync(id);
            return NoContent();
        }
    }
}