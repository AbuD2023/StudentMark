using System.Text.Json.Serialization;

namespace API.DTOs
{
    public class AttendanceResponseDto
    {
        public int Id { get; set; }
        public int StudentId { get; set; }
        public string StudentName { get; set; }
        public int ScheduleId { get; set; }
        public int QRCodeId { get; set; }
        public DateTime AttendanceDate { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}