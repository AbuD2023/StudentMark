using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class LectureScheduleDto
    {
        [Required]
        public int CourseSubjectId { get; set; }

        [Required]
        public int DoctorId { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public int LevelId { get; set; }

        [Required]
        [Range(0, 6)]
        public DayOfWeek DayOfWeek { get; set; }

        [Required]
        public TimeSpan StartTime { get; set; }

        [Required]
        public TimeSpan EndTime { get; set; }
    }
}