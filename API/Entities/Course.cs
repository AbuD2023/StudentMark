using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Courses")]
    public class Course : BaseEntity
    {
        // [Key]
        // public int CourseId { get; set; }

        [Required]
        [StringLength(100)]
        public string CourseName { get; set; }

        [StringLength(200)]
        public string? Description { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("DepartmentId")]
        public Department Department { get; set; }

        public ICollection<CourseSubject> CourseSubjects { get; set; }

        public ICollection<LectureSchedule> LectureSchedules { get; set; }
    }
}