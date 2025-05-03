using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class SubjectDto
    {
        [Required]
        [StringLength(100)]
        public string SubjectName { get; set; }

        [StringLength(200)]
        public string? Description { get; set; }
    }
}