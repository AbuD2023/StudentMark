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
    public class DepartmentController : ControllerBase
    {
        private readonly IDepartmentService _departmentService;

        public DepartmentController(IDepartmentService departmentService)
        {
            _departmentService = departmentService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Department>>> GetDepartments()
        {
            var departments = await _departmentService.GetAllAsync();
            return Ok(departments);
        }

        [HttpGet("active")]
        public async Task<ActionResult<IEnumerable<Department>>> GetActiveDepartments()
        {
            var departments = await _departmentService.GetActiveDepartmentsAsync();
            return Ok(departments);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Department>> GetDepartment(int id)
        {
            var department = await _departmentService.GetByIdAsync(id);
            if (department == null)
            {
                return NotFound(new { message = "Department not found" });
            }
            return Ok(department);
        }

        [HttpGet("{id}/with-levels")]
        public async Task<ActionResult<Department>> GetDepartmentWithLevels(int id)
        {
            var department = await _departmentService.GetDepartmentWithLevelsAsync(id);
            if (department == null)
            {
                return NotFound(new { message = "Department not found" });
            }
            return Ok(department);
        }

        [HttpGet("{id}/courses")]
        public async Task<ActionResult<IEnumerable<Course>>> GetDepartmentCourses(int id)
        {
            var courses = await _departmentService.GetDepartmentCoursesAsync(id);
            return Ok(courses);
        }

        [HttpGet("{id}/students")]
        public async Task<ActionResult<IEnumerable<Student>>> GetDepartmentStudents(int id)
        {
            var students = await _departmentService.GetDepartmentStudentsAsync(id);
            return Ok(students);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Department>> CreateDepartment([FromBody] DepartmentDto departmentDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if department name is unique
            if (!await _departmentService.IsDepartmentNameUniqueAsync(departmentDto.DepartmentName))
            {
                return BadRequest(new { message = "Department name already exists" });
            }

            var department = new Department
            {
                Id=0,
                DepartmentName = departmentDto.DepartmentName,
                Description = departmentDto.Description,
                IsActive = true
            };

            await _departmentService.AddAsync(department);
            return CreatedAtAction(nameof(GetDepartment), new { id = department.Id }, department);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateDepartment(int id, [FromBody] DepartmentDto departmentDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var department = await _departmentService.GetByIdAsync(id);
            if (department == null)
            {
                return NotFound(new { message = "Department not found" });
            }

            // Check if department name is unique (if name is being changed)
            if (department.DepartmentName != departmentDto.DepartmentName &&
                !await _departmentService.IsDepartmentNameUniqueAsync(departmentDto.DepartmentName))
            {
                return BadRequest(new { message = "Department name already exists" });
            }

            department.DepartmentName = departmentDto.DepartmentName;
            department.Description = departmentDto.Description;

            await _departmentService.UpdateAsync(department);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleDepartmentStatus(int id)
        {
            var department = await _departmentService.GetByIdAsync(id);
            if (department == null)
            {
                return NotFound(new { message = "Department not found" });
            }

            department.IsActive = !department.IsActive;
            await _departmentService.UpdateAsync(department);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteDepartment(int id)
        {
            var department = await _departmentService.GetByIdAsync(id);
            if (department == null)
            {
                return NotFound(new { message = "Department not found" });
            }

            await _departmentService.DeleteAsync(id);
            return NoContent();
        }
    }
}