using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("QRCodes")]
    public class QRCode : BaseEntity
    {
        // [Key]
        // public int QRCodeId { get; set; }

        [Required]
        public int ScheduleId { get; set; }

        [Required]
        public int DoctorId { get; set; }

        [Required]
        public string QRCodeValue { get; set; }

        [Required]
        public DateTime GeneratedAt { get; set; }

        [Required]
        public DateTime ExpiresAt { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        // Navigation Properties
        [ForeignKey("ScheduleId")]
        public LectureSchedule LectureSchedule { get; set; }

        [ForeignKey("DoctorId")]
        public User Doctor { get; set; }

        public ICollection<Attendance> Attendances { get; set; }
    }
}