using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class CourseSubjectResponseDto
    {
        public int Id { get; set; }
        public int CourseId { get; set; }
        public string CourseName { get; set; }
        public int SubjectId { get; set; }
        public string SubjectName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public ICollection<LectureScheduleResponseDto> LectureSchedules { get; set; }
    }
} 