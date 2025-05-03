using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class ReportDto
    {
        [Required]
        public string ReportType { get; set; }

        [Required]
        public DateTime StartDate { get; set; }

        [Required]
        public DateTime EndDate { get; set; }

        public int? DepartmentId { get; set; }
        public int? LevelId { get; set; }
        public int? DoctorId { get; set; }
        public int? StudentId { get; set; }
        public int? CourseSubjectId { get; set; }
    }
}