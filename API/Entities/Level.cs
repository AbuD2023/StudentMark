using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Levels")]
    public class Level : BaseEntity
    {
        // [Key]
        // public int LevelId { get; set; }

        [Required]
        [StringLength(50)]
        public string LevelName { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("DepartmentId")]
        public Department? Department { get; set; }

        public ICollection<Student>? Students { get; set; }

        public ICollection<CourseSubject>? CourseSubjects { get; set; }

        public ICollection<DoctorDepartmentsLevels>? DoctorDepartmentsLevels { get; set; }

        public ICollection<LectureSchedule>? LectureSchedules { get; set; }
    }
}