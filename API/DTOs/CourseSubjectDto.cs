using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class CourseSubjectDto
    {
        [Required]
        public int CourseId { get; set; }

        [Required]
        public int SubjectId { get; set; }

        [Required]  
        public int LevelId { get; set; }
    }
}