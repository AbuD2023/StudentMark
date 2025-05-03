// namespace API.DTOs.Lectures
// {
//     public class LectureScheduleDto
//     {
//         public int ScheduleId { get; set; }
//         public int CourseSubjectId { get; set; }
//         public string CourseName { get; set; }
//         public string SubjectName { get; set; }
//         public int DoctorId { get; set; }
//         public string DoctorName { get; set; }
//         public string DepartmentName { get; set; }
//         public string LevelName { get; set; }
//         public string Room { get; set; }
//         public DayOfWeek DayOfWeek { get; set; }
//         public TimeSpan StartTime { get; set; }
//         public TimeSpan EndTime { get; set; }
//         public bool IsActive { get; set; }
//         public QRCodeDto? CurrentQRCode { get; set; }
//         public List<AttendanceDto> Attendances { get; set; }
//     }

//     public class CreateLectureScheduleDto
//     {
//         public int CourseSubjectId { get; set; }
//         public int DoctorId { get; set; }
//         public string Room { get; set; }
//         public DayOfWeek DayOfWeek { get; set; }
//         public TimeSpan StartTime { get; set; }
//         public TimeSpan EndTime { get; set; }
//     }

//     public class QRCodeDto
//     {
//         public int QRCodeId { get; set; }
//         public string QRCodeValue { get; set; }
//         public DateTime GeneratedAt { get; set; }
//         public DateTime ExpiresAt { get; set; }
//         public bool IsActive { get; set; }
//     }

//     public class AttendanceDto
//     {
//         public int AttendanceId { get; set; }
//         public int StudentId { get; set; }
//         public string StudentName { get; set; }
//         public DateTime AttendanceDate { get; set; }
//         public bool Status { get; set; }
//         public string? StudentNote { get; set; }
//         public string? DoctorNote { get; set; }
//     }
// }