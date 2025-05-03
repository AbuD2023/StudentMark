using API.DTOs;

namespace API.Services.Interfaces
{
    public interface IAttendanceReportService
    {
        Task<AttendanceReportDto> GetAttendanceByScheduleAsync(int scheduleId);
        Task<AttendanceReportDto> GetAttendanceByDoctorAsync(int doctorId);
        Task<AttendanceReportDto> GetAttendanceByStudentAsync(int studentId);
        Task<AttendanceReportDto> GetAttendanceByDepartmentAsync(int departmentId);
        Task<AttendanceReportDto> GetAttendanceByLevelAsync(int levelId);
        Task<AttendanceReportDto> GetAttendanceByDateRangeAsync(DateTime startDate, DateTime endDate);
    }
}