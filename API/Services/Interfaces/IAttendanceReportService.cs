using API.DTOs;
using API.Entities;

namespace API.Services.Interfaces
{
    public interface IAttendanceReportService
    {
        Task<AttendanceReportDto> GetAttendanceByScheduleAsync(int scheduleId);
        Task<AttendanceReportDto> GetAttendanceByDoctorAsync(int doctorId);
        Task<AttendanceReportDto> GetAttendanceByStudentAsync(int studentId);
        Task<AttendanceReportDto> GetAttendancesByDoctorAsync(int doctorId);
        Task<AttendanceReportDto> GetAttendanceByDepartmentAsync(int departmentId);
        Task<AttendanceReportDto> GetAttendanceByLevelAsync(int levelId);
        Task<AttendanceReportDto> GetAttendanceByDateRangeAsync(DateTime startDate, DateTime endDate);
    }
}