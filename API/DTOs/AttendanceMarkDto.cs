namespace API.DTOs
{
    public class AttendanceMarkDto
    {
        public required int StudentId { get; set; }
        public required string QRCodeValue { get; set; }
    }
}