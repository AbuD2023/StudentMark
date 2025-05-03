using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IAttendanceRepository : IGenericRepository<Attendance>
    {
        Task<IEnumerable<Attendance>> GetAttendancesByStudentAsync(int studentId);
        Task<IEnumerable<Attendance>> GetAttendancesByScheduleAsync(int scheduleId);
        Task<IEnumerable<Attendance>> GetAttendancesByQRCodeAsync(int qrCodeId);
        Task<IEnumerable<Attendance>> GetAttendancesByDateRangeAsync(DateTime startDate, DateTime endDate);
        Task<bool> IsAttendanceUniqueAsync(int studentId, int scheduleId, DateTime attendanceDate);
    }
}