using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class StudentDto
    {
        [Required]
        public int UserId { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public int LevelId { get; set; }

        [Required]
        [Range(2000, 2100)]
        public int EnrollmentYear { get; set; }

        public string? AcademicId { get; set; }
    }
}