using API.DTOs;
using API.Entities;
using API.Services;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class CourseSubjectController : ControllerBase
    {
        private readonly ICourseSubjectService _courseSubjectService;

        public CourseSubjectController(ICourseSubjectService courseSubjectService)
        {
            _courseSubjectService = courseSubjectService;
        }

        [HttpGet("course/{courseId}")]
        public async Task<ActionResult<IEnumerable<CourseSubject>>> GetCourseSubjectsByCourse(int courseId)
        {
            var courseSubjects = await _courseSubjectService.GetCourseSubjectsByCourseAsync(courseId);
            return Ok(courseSubjects);
        }

        [HttpGet("subject/{subjectId}")]
        public async Task<ActionResult<IEnumerable<CourseSubject>>> GetCourseSubjectsBySubject(int subjectId)
        {
            var courseSubjects = await _courseSubjectService.GetCourseSubjectsBySubjectAsync(subjectId);
            return Ok(courseSubjects);
        }

        [HttpGet("level/{levelId}")]
        public async Task<ActionResult<IEnumerable<CourseSubject>>> GetCourseSubjectsByLevel(int levelId)
        {
            var courseSubjects = await _courseSubjectService.GetCourseSubjectsByLevelAsync(levelId);
            return Ok(courseSubjects);
        }

        [HttpPost]
        public async Task<ActionResult<CourseSubject>> CreateCourseSubject([FromBody] CourseSubjectDto courseSubject)
        {
            // Check if the combination is unique
            var isUnique = await _courseSubjectService.IsCourseSubjectUniqueAsync(
                courseSubject.CourseId,
                courseSubject.SubjectId,
                courseSubject.LevelId
            );

            if (!isUnique)
            {
                return BadRequest("This subject is already assigned to this course and level");
            }

            var courseSubjectData = new CourseSubject { 
                CourseId = courseSubject.CourseId,
                SubjectId = courseSubject.SubjectId,
                LevelId = courseSubject.LevelId,
            };

            var createdCourseSubject = await _courseSubjectService.AddAsync(courseSubjectData);
            return CreatedAtAction(nameof(GetCourseSubjectsByCourse), new { courseId = createdCourseSubject.CourseId }, createdCourseSubject);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<ActionResult<CourseSubject>> UpdateCourseSubject(int id, [FromBody] CourseSubjectDto courseSubject)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var courseSub = await _courseSubjectService.GetByIdAsync(id);
            if (courseSub == null)
            {
                return NotFound(new { message = "Course Subject not found" });
            }
            // Check if the combination is unique
            var isUnique = await _courseSubjectService.IsCourseSubjectUniqueAsync(
                courseSubject.CourseId,
                courseSubject.SubjectId,
                courseSubject.LevelId
            );

            if (!isUnique)
            {
                return BadRequest("This subject is already assigned to this course and level");
            }

            courseSub.CourseId = courseSubject.CourseId;
            courseSub.SubjectId = courseSubject.SubjectId;
            courseSub.LevelId = courseSubject.LevelId;
            courseSub.IsActive = true;
            await _courseSubjectService.UpdateAsync(courseSub);

            return Ok(new
            {
                Message = "تمت  الإضافة بنجاح",
                CourseSubject = courseSubject,
            });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCourseSubject(int id)
        {
            await _courseSubjectService.DeleteAsync(id);
            return NoContent();
        }

        [HttpGet("{id}/schedules")]
        public async Task<ActionResult<IEnumerable<LectureSchedule>>> GetCourseSubjectSchedules(int id)
        {
            var schedules = await _courseSubjectService.GetCourseSubjectSchedulesAsync(id);
            return Ok(schedules);
        }
    }
}