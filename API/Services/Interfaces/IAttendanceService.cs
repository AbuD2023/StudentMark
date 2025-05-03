using API.Entities;

namespace API.Services.Interfaces
{
    public interface IAttendanceService : IGenericService<Attendance>
    {
        Task<IEnumerable<Attendance>> GetAttendancesByStudentAsync(int studentId);
        Task<IEnumerable<Attendance>> GetAttendancesByScheduleAsync(int scheduleId);
        Task<IEnumerable<Attendance>> GetAttendancesByQRCodeAsync(int qrCodeId);
        Task<IEnumerable<Attendance>> GetAttendancesByDateRangeAsync(DateTime startDate, DateTime endDate);
        Task<bool> IsAttendanceUniqueAsync(int studentId, int scheduleId, DateTime attendanceDate);
        Task<bool> MarkAttendanceAsync(int studentId, string qrCodeValue);
        Task<IEnumerable<Attendance>> GetStudentAttendanceReportAsync(int studentId, DateTime startDate, DateTime endDate);
    }
} 