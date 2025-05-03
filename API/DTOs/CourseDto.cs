using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class CourseDto
    {
        [Required]
        [StringLength(100)]
        public string CourseName { get; set; }

        [StringLength(500)]
        public string? Description { get; set; }

        [Required]
        public int DepartmentId { get; set; }
    }
}