using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class QRCodeResponseDto
    {
        public int Id { get; set; }
        public string QRCodeValue { get; set; }
        public int ScheduleId { get; set; }
        public int DoctorId { get; set; }
        public string DoctorName { get; set; }
        public DateTime ExpiryTime { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public ICollection<AttendanceResponseDto> Attendances { get; set; }
    }
}