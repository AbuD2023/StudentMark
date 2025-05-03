using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class AttendanceReportDto
    {
        [Required]
        public int ScheduleId { get; set; }

        [Required]
        public string CourseName { get; set; }

        [Required]
        public string LevelName { get; set; }

        [Required]
        public string DepartmentName { get; set; }

        [Required]
        public DateTime LectureDate { get; set; }

        [Required]
        public int TotalStudents { get; set; }

        [Required]
        public int PresentStudents { get; set; }

        [Required]
        public int AbsentStudents { get; set; }

        [Required]
        public double AttendancePercentage { get; set; }

        public List<StudentAttendanceDto> StudentAttendances { get; set; }
    }

    public class StudentAttendanceDto
    {
        [Required]
        public int StudentId { get; set; }

        [Required]
        public string StudentName { get; set; }

        [Required]
        public string StudentNumber { get; set; }

        [Required]
        public bool IsPresent { get; set; }

        public DateTime? AttendanceTime { get; set; }
    }
}