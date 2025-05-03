using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class LevelDto
    {
        [Required]
        [StringLength(50)]
        public string LevelName { get; set; }

        [Required]
        public int DepartmentId { get; set; }
    }
}