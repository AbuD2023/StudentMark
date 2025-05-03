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
    public class SubjectController : ControllerBase
    {
        private readonly ISubjectService _subjectService;

        public SubjectController(ISubjectService subjectService)
        {
            _subjectService = subjectService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Subject>>> GetSubjects()
        {
            var subjects = await _subjectService.GetAllAsync();
            return Ok(subjects);
        }

        [HttpGet("active")]
        public async Task<ActionResult<IEnumerable<Subject>>> GetActiveSubjects()
        {
            var subjects = await _subjectService.GetActiveSubjectsAsync();
            return Ok(subjects);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Subject>> GetSubject(int id)
        {
            var subject = await _subjectService.GetByIdAsync(id);
            if (subject == null)
            {
                return NotFound(new { message = "Subject not found" });
            }
            return Ok(subject);
        }

        [HttpGet("{id}/with-courses")]
        public async Task<ActionResult<Subject>> GetSubjectWithCourses(int id)
        {
            var subject = await _subjectService.GetSubjectWithCoursesAsync(id);
            if (subject == null)
            {
                return NotFound(new { message = "Subject not found" });
            }
            return Ok(subject);
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<Subject>> CreateSubject([FromBody] SubjectDto subjectDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Check if subject name is unique
            if (!await _subjectService.IsSubjectNameUniqueAsync(subjectDto.SubjectName))
            {
                return BadRequest(new { message = "Subject name already exists" });
            }

            var subject = new Subject
            {
                SubjectName = subjectDto.SubjectName,
                Description = subjectDto.Description,
                IsActive = true
            };

            await _subjectService.AddAsync(subject);
            return CreatedAtAction(nameof(GetSubject), new { id = subject.Id }, subject);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateSubject(int id, [FromBody] SubjectDto subjectDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var subject = await _subjectService.GetByIdAsync(id);
            if (subject == null)
            {
                return NotFound(new { message = "Subject not found" });
            }

            // Check if subject name is unique (if name is being changed)
            if (subject.SubjectName != subjectDto.SubjectName &&
                !await _subjectService.IsSubjectNameUniqueAsync(subjectDto.SubjectName))
            {
                return BadRequest(new { message = "Subject name already exists" });
            }

            subject.SubjectName = subjectDto.SubjectName;
            subject.Description = subjectDto.Description;

            await _subjectService.UpdateAsync(subject);
            return NoContent();
        }

        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> ToggleSubjectStatus(int id)
        {
            var subject = await _subjectService.GetByIdAsync(id);
            if (subject == null)
            {
                return NotFound(new { message = "Subject not found" });
            }

            subject.IsActive = !subject.IsActive;
            await _subjectService.UpdateAsync(subject);
            return NoContent();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteSubject(int id)
        {
            var subject = await _subjectService.GetByIdAsync(id);
            if (subject == null)
            {
                return NotFound(new { message = "Subject not found" });
            }

            await _subjectService.DeleteAsync(id);
            return NoContent();
        }
    }
}