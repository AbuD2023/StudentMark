// namespace API.DTOs.Doctors
// {
//     public class DoctorScheduleDto
//     {
//         public int ScheduleId { get; set; }
//         public int CourseSubjectId { get; set; }
//         public string CourseName { get; set; }
//         public string SubjectName { get; set; }
//         public string DepartmentName { get; set; }
//         public string LevelName { get; set; }
//         public string Room { get; set; }
//         public DayOfWeek DayOfWeek { get; set; }
//         public TimeSpan StartTime { get; set; }
//         public TimeSpan EndTime { get; set; }
//         public bool IsActive { get; set; }
//         public QRCodeDto? CurrentQRCode { get; set; }
//     }

//     public class QRCodeDto
//     {
//         public int QRCodeId { get; set; }
//         public string QRCodeValue { get; set; }
//         public DateTime GeneratedAt { get; set; }
//         public DateTime ExpiresAt { get; set; }
//         public bool IsActive { get; set; }
//     }
// }