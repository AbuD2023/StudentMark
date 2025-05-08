using API.DTOs;
using API.Entities;

namespace API.Services.Interfaces
{
    public interface ILectureScheduleService : IGenericService<LectureSchedule>
    {
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDoctorAsync(int doctorId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseSubjectAsync(int courseSubjectId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDepartmentAsync(int departmentId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByLevelAsync(int levelId);
        Task<IEnumerable<LectureSchedule>> GetActiveSchedulesAsync();
        Task<IEnumerable<LectureSchedule>> GetAllSchedulesAsync();
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDateRangeAsync(DateTime startDate, DateTime endDate);
        Task<bool> IsTimeSlotAvailableAsync(int doctorId, DayOfWeek dayOfWeek, TimeSpan startTime, TimeSpan endTime);
        Task<IEnumerable<QRCode>> GetScheduleQRCodesAsync(int scheduleId);
        Task<IEnumerable<RoomDto>> GetAllRoomsAsync();
        Task<IEnumerable<Attendance>> GetScheduleAttendancesAsync(int scheduleId);
    }
} 