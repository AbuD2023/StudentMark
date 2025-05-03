using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("LectureSchedules")]
    public class LectureSchedule: BaseEntity
    {
        // [Key]
        // public int ScheduleId { get; set; }

        [Required]
        public int CourseSubjectId { get; set; }

        [Required]
        public int DoctorId { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        [Required]
        public int LevelId { get; set; }

        [Required]
        public DayOfWeek DayOfWeek { get; set; }

        [Required]
        public TimeSpan StartTime { get; set; }

        [Required]
        public TimeSpan EndTime { get; set; }

        [Required]
        [StringLength(50)]
        public string Room { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("CourseSubjectId")]
        public CourseSubject? CourseSubject { get; set; }

        [ForeignKey("DoctorId")]
        public User? Doctor { get; set; }

        [ForeignKey("DepartmentId")]
        public Department? Department { get; set; }

        [ForeignKey("LevelId")]
        public Level? Level { get; set; }

        public ICollection<QRCode>? QRCodes { get; set; }

        public ICollection<Attendance>? Attendances { get; set; }
    }
}