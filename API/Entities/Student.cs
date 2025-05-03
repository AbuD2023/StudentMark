using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Students")]
    public class Student : BaseEntity
    {
        // [Key]
        // public int StudentId { get; set; }

        [Required]
        public int UserId { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public int LevelId { get; set; }

        [Required]
        public int EnrollmentYear { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("UserId")]
        public User? User { get; set; }

        [ForeignKey("DepartmentId")]
        public Department? Department { get; set; }

        [ForeignKey("LevelId")]
        public Level? Level { get; set; }

        public ICollection<Attendance>? Attendances { get; set; }
    }
}