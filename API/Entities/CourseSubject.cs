using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("CourseSubjects")]
    public class CourseSubject : BaseEntity
    {
        // [Key]
        // public int CourseSubjectId { get; set; }

        [Required]
        public int CourseId { get; set; }

        [Required]
        public int SubjectId { get; set; }

        [Required]
        public int LevelId { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("CourseId")]
        public Course Course { get; set; }

        [ForeignKey("SubjectId")]
        public Subject Subject { get; set; }

        [ForeignKey("LevelId")]
        public Level Level { get; set; }

        public ICollection<LectureSchedule> LectureSchedules { get; set; }
    }
}