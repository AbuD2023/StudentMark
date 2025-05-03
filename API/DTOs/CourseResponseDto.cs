using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class CourseResponseDto
    {
        public int Id { get; set; }
        public string CourseName { get; set; }
        public string? Description { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public ICollection<SubjectResponseDto> Subjects { get; set; }
    }
}