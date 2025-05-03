using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class DepartmentDto
    {
        [Required]
        [StringLength(100)]
        public string DepartmentName { get; set; }

        [StringLength(200)]
        public string? Description { get; set; }
    }
}