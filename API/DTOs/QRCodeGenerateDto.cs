using System.ComponentModel.DataAnnotations;

namespace API.DTOs
{
    public class QRCodeGenerateDto
    {
        [Required]
        public int ScheduleId { get; set; }

        [Required]
        public int DoctorId { get; set; }

        [Required]
        public DateTime ExpiryTime { get; set; }
    }
}