using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class StudentResponseDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string FullName { get; set; }
        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public int EnrollmentYear { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public ICollection<AttendanceResponseDto> Attendances { get; set; }
    }
}