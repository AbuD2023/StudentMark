using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Attendances")]
    public class Attendance : BaseEntity
    {
        // [Key]
        // public int AttendanceId { get; set; }

        [Required]
        public int StudentId { get; set; }

        [Required]
        public int ScheduleId { get; set; }

        [Required]
        public int QRCodeId { get; set; }

        [Required]
        public DateTime AttendanceDate { get; set; }

        [Required]
        public bool Status { get; set; }  // true for Present, false for Absent

        [StringLength(500)]
        public string? StudentNote { get; set; }

        [StringLength(500)]
        public string? DoctorNote { get; set; }

        // Navigation Properties
        [ForeignKey("StudentId")]
        public Student Student { get; set; }

        [ForeignKey("ScheduleId")]
        public LectureSchedule LectureSchedule { get; set; }

        [ForeignKey("QRCodeId")]
        public QRCode QRCode { get; set; }
    }
}