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
    public class LevelController : ControllerBase
    {
        private readonly ILevelService _levelService;

        public LevelController(ILevelService levelService)
        {
            _levelService = levelService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Level>>> GetLevels()
        {
            var levels = await _levelService.GetAllAsyncCopy();
            return Ok(levels);
        }

        [HttpGet("active")]
        public async Task<ActionResult<IEnumerable<Level>>> GetActiveLevels()
        {
            var levels = await _levelService.GetActiveLevelsAsync();
            return Ok(levels);
        }

        [HttpGet("department/{departmentId}")]
        public async Task<ActionResult<IEnumerable<Level>>> GetLevelsByDepartment(int departmentId)
        {
            var levels = await _levelService.GetLevelsByDepartmentAsync(departmentId);
            return Ok(levels);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Level>> GetLevel(int id)
        {
            var level = await _levelService.GetByIdAsync(id);
            if (level == null)
            {
                return NotFound(new { message = "Level not found" });
            }
            return Ok(level);
        }

        [HttpGet("{id}/courses")]
        public async Task<ActionResult<IEnumerable<Course>>> GetLevelCourses(int id)
        {
            var courses = await _levelService.GetLevelCoursesAsync(id);
            return Ok(courses);
        }

        [HttpGet("{id}/students")]
        public async Task<ActionResult<IEnumerable<Student>>> GetLevelStudents(int id)
        {
            var students = await _levelService.GetLevelStudentsAsync(id);
            return Ok(students);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Level>> CreateLevel([FromBody] LevelDto levelDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if level name is unique in the department
            if (!await _levelService.IsLevelNameUniqueInDepartmentAsync(levelDto.LevelName, levelDto.DepartmentId))
            {
                return BadRequest(new { message = "Level name already exists in this department" });
            }

            var level = new Level
            {
                LevelName = levelDto.LevelName,
                DepartmentId = levelDto.DepartmentId,
                IsActive = true
            };

            await _levelService.AddAsync(level);
            return CreatedAtAction(nameof(GetLevel), new { id = level.Id }, level);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateLevel(int id, [FromBody] LevelDto levelDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var level = await _levelService.GetByIdAsync(id);
            if (level == null)
            {
                return NotFound(new { message = "Level not found" });
            }

            // Check if level name is unique in the department (if name is being changed)
            if (level.LevelName != levelDto.LevelName &&
                !await _levelService.IsLevelNameUniqueInDepartmentAsync(levelDto.LevelName, levelDto.DepartmentId))
            {
                return BadRequest(new { message = "Level name already exists in this department" });
            }

            level.LevelName = levelDto.LevelName;
            level.DepartmentId = levelDto.DepartmentId;

            await _levelService.UpdateAsync(level);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleLevelStatus(int id)
        {
            var level = await _levelService.GetByIdAsync(id);
            if (level == null)
            {
                return NotFound(new { message = "Level not found" });
            }

            level.IsActive = !level.IsActive;
            await _levelService.UpdateAsync(level);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteLevel(int id)
        {
            var level = await _levelService.GetByIdAsync(id);
            if (level == null)
            {
                return NotFound(new { message = "Level not found" });
            }

            await _levelService.DeleteAsync(id);
            return NoContent();
        }
    }
}