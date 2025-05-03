using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace API.Entities
{
    [Table("Users")]
    public class User : BaseEntity
    {
        [Required]
        [StringLength(100)]
        public string FullName { get; set; }
        public string? RefreshToken { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? RefreshTokenExpiryTime { get; set; } = DateTime.UtcNow;

        public DateTime? LastLoginAt { get; set; }

        // Navigation Properties
        public int RoleId { get; set; }
        public Role? Role { get; set; }

        public Student? Student { get; set; }

        public ICollection<LectureSchedule>? LectureSchedules { get; set; }

        public ICollection<DoctorDepartmentsLevels>? DoctorDepartmentsLevels { get; set; }

        public ICollection<QRCode>? GeneratedQRCodes { get; set; }

        public ICollection<Attendance>? Attendances { get; set; }
    }
}