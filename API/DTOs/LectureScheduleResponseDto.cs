using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class LectureScheduleResponseDto
    {
        public int Id { get; set; }
        public int CourseSubjectId { get; set; }
        public string CourseName { get; set; }
        public string SubjectName { get; set; }
        public int DoctorId { get; set; }
        public string DoctorName { get; set; }
        public int DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public DayOfWeek DayOfWeek { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public ICollection<QRCodeResponseDto> QRCodes { get; set; }
        public ICollection<AttendanceResponseDto> Attendances { get; set; }
    }
}