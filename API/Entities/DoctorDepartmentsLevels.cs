using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("DoctorDepartmentsLevels")]
    [PrimaryKey(nameof(Id))]
    public class DoctorDepartmentsLevels : BaseEntity
    {
        // [Key]
        // public int DoctorDepartmentsLevelsId { get; set; }

        //[Required]
        public int DoctorId { get; set; }

        //[Required]
        public int DepartmentId { get; set; }

        //[Required]
        public int LevelId { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("DoctorId")]
        public User Doctor { get; set; }

        [ForeignKey("DepartmentId")]
        public Department Department { get; set; }

        [ForeignKey("LevelId")]
        public Level Level { get; set; }
    }
}