using API.DTOs;
using API.Entities;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class CourseController : ControllerBase
    {
        private readonly ICourseService _courseService;

        public CourseController(ICourseService courseService)
        {
            _courseService = courseService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Course>>> GetCourses()
        {
            var courses = await _courseService.GetAllAsync();
            return Ok(courses);
        }

        [HttpGet("active")]
        public async Task<ActionResult<IEnumerable<Course>>> GetActiveCourses()
        {
            var courses = await _courseService.GetActiveCoursesAsync();
            return Ok(courses);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Course>> GetCourse(int id)
        {
            var course = await _courseService.GetByIdAsync(id);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }
            return Ok(course);
        }

        [HttpGet("{id}/with-subjects")]
        public async Task<ActionResult<Course>> GetCourseWithSubjects(int id)
        {
            var course = await _courseService.GetCourseWithSubjectsAsync(id);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }
            return Ok(course);
        }

        [HttpGet("department/{departmentId}")]
        public async Task<ActionResult<IEnumerable<Course>>> GetCoursesByDepartment(int departmentId)
        {
            var courses = await _courseService.GetCoursesByDepartmentAsync(departmentId);
            return Ok(courses);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Course>> CreateCourse([FromBody] CourseDto courseDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if course name is unique in the department
            if (!await _courseService.IsCourseNameUniqueInDepartmentAsync(courseDto.CourseName, courseDto.DepartmentId))
            {
                return BadRequest(new { message = "Course name already exists in this department" });
            }

            var course = new Course
            {
                CourseName = courseDto.CourseName,
                Description = courseDto.Description,
                DepartmentId = courseDto.DepartmentId,
                IsActive = true
            };

            await _courseService.AddAsync(course);
            return CreatedAtAction(nameof(GetCourse), new { id = course.Id }, course);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateCourse(int id, [FromBody] CourseDto courseDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var course = await _courseService.GetByIdAsync(id);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            // Check if course name is unique in the department (if name is being changed)
            if (course.CourseName != courseDto.CourseName &&
                !await _courseService.IsCourseNameUniqueInDepartmentAsync(courseDto.CourseName, courseDto.DepartmentId))
            {
                return BadRequest(new { message = "Course name already exists in this department" });
            }

            course.CourseName = courseDto.CourseName;
            course.Description = courseDto.Description;
            course.DepartmentId = courseDto.DepartmentId;

            await _courseService.UpdateAsync(course);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleCourseStatus(int id)
        {
            var course = await _courseService.GetByIdAsync(id);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            course.IsActive = !course.IsActive;
            await _courseService.UpdateAsync(course);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteCourse(int id)
        {
            var course = await _courseService.GetByIdAsync(id);
            if (course == null)
            {
                return NotFound(new { message = "Course not found" });
            }

            await _courseService.DeleteAsync(id);
            return NoContent();
        }
    }
}