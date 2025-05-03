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
    public class DoctorController : ControllerBase
    {
        private readonly IDoctorDepartmentsLevelsService _doctorService;

        public DoctorController(IDoctorDepartmentsLevelsService doctorService)
        {
            _doctorService = doctorService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<DoctorDepartmentsLevels>>> GetDoctorAssignments()
        {
            var assignments = await _doctorService.GetAllAsync();
            return Ok(assignments);
        }

        [HttpGet("active")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<DoctorDepartmentsLevels>>> GetActiveDoctorAssignments()
        {
            var assignments = await _doctorService.GetActiveAssignmentsAsync();
            return Ok(assignments);
        }

        [HttpGet("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<DoctorDepartmentsLevels>> GetDoctorAssignment(int id)
        {
            var assignment = await _doctorService.GetByIdAsync(id);
            if (assignment == null)
            {
                return NotFound(new { message = "Doctor assignment not found" });
            }
            return Ok(assignment);
        }

        [HttpGet("doctor/{doctorId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<DoctorDepartmentsLevels>>> GetAssignmentsByDoctor(int doctorId)
        {
            var assignments = await _doctorService.GetByDoctorAsync(doctorId);
            return Ok(assignments);
        }

        [HttpGet("department/{departmentId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<DoctorDepartmentsLevels>>> GetAssignmentsByDepartment(int departmentId)
        {
            var assignments = await _doctorService.GetByDepartmentAsync(departmentId);
            return Ok(assignments);
        }

        [HttpGet("level/{levelId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<IEnumerable<DoctorDepartmentsLevels>>> GetAssignmentsByLevel(int levelId)
        {
            var assignments = await _doctorService.GetByLevelAsync(levelId);
            return Ok(assignments);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<DoctorDepartmentsLevels>> CreateDoctorAssignment([FromBody] DoctorDto doctorDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if assignment is unique
            if (!await _doctorService.IsAssignmentUniqueAsync(doctorDto.DoctorId, doctorDto.DepartmentId, doctorDto.LevelId))
            {
                return BadRequest(new { message = "Doctor is already assigned to this department and level" });
            }

            var assignment = new DoctorDepartmentsLevels
            {
                DoctorId = doctorDto.DoctorId,
                DepartmentId = doctorDto.DepartmentId,
                LevelId = doctorDto.LevelId,
                IsActive = true
            };

            await _doctorService.AddAsync(assignment);
            return CreatedAtAction(nameof(GetDoctorAssignment), new { id = assignment.Id }, assignment);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateDoctorAssignment(int id, [FromBody] DoctorDto doctorDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var assignment = await _doctorService.GetByIdAsync(id);
            if (assignment == null)
            {
                return NotFound(new { message = "Doctor assignment not found" });
            }

            // Check if new assignment is unique
            if (assignment.DoctorId != doctorDto.DoctorId ||
                assignment.DepartmentId != doctorDto.DepartmentId ||
                assignment.LevelId != doctorDto.LevelId)
            {
                if (!await _doctorService.IsAssignmentUniqueAsync(doctorDto.DoctorId, doctorDto.DepartmentId, doctorDto.LevelId))
                {
                    return BadRequest(new { message = "Doctor is already assigned to this department and level" });
                }
            }

            assignment.DoctorId = doctorDto.DoctorId;
            assignment.DepartmentId = doctorDto.DepartmentId;
            assignment.LevelId = doctorDto.LevelId;

            await _doctorService.UpdateAsync(assignment);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleDoctorAssignmentStatus(int id)
        {
            var assignment = await _doctorService.GetByIdAsync(id);
            if (assignment == null)
            {
                return NotFound(new { message = "Doctor assignment not found" });
            }

            assignment.IsActive = !assignment.IsActive;
            await _doctorService.UpdateAsync(assignment);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteDoctorAssignment(int id)
        {
            var assignment = await _doctorService.GetByIdAsync(id);
            if (assignment == null)
            {
                return NotFound(new { message = "Doctor assignment not found" });
            }

            await _doctorService.DeleteAsync(id);
            return NoContent();
        }
    }
}