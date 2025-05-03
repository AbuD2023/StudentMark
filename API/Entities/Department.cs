using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Departments")]
    public class Department : BaseEntity
    {
        // [Key]
        // public int DepartmentId { get; set; }

        [Required]
        [StringLength(100)]
        public string DepartmentName { get; set; }

        [StringLength(200)]
        public string? Description { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        public ICollection<Level>? Levels { get; set; }

        public ICollection<Course>? Courses { get; set; }

        public ICollection<Student>? Students { get; set; }

        public ICollection<DoctorDepartmentsLevels>? DoctorDepartmentsLevels { get; set; }

        public ICollection<LectureSchedule>? LectureSchedules { get; set; }
    }
}