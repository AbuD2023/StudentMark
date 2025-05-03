using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class DoctorDto
    {
        [Required]
        public int DoctorId { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public int LevelId { get; set; }
    }
}