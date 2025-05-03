using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Subjects")]
    public class Subject : BaseEntity
    {
        // [Key]
        // public int SubjectId { get; set; }

        [Required]
        [StringLength(100)]
        public string SubjectName { get; set; }

        [StringLength(200)]
        public string? Description { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        public ICollection<CourseSubject> CourseSubjects { get; set; }

        public ICollection<LectureSchedule> LectureSchedules { get; set; }
    }
}