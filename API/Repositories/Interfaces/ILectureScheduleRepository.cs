using API.DTOs;
using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface ILectureScheduleRepository : IGenericRepository<LectureSchedule>
    {
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDoctorAsync(int doctorId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseSubjectAsync(int courseSubjectId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseAsync(int courseId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDepartmentAsync(int departmentId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByLevelAsync(int levelId);
        Task<IEnumerable<LectureSchedule>> GetSchedulesByDateRangeAsync(DateTime startDate, DateTime endDate);
        Task<IEnumerable<LectureSchedule>> GetActiveSchedulesAsync();
        Task<IEnumerable<LectureSchedule>> GetAllSchedulesAsync();
        Task<IEnumerable<RoomDto>> GetAllRoomsAsync();
        Task<bool> IsTimeSlotAvailableAsync(int doctorId, int LectureScheduleId, DayOfWeek dayOfWeek, TimeSpan startTime, TimeSpan endTime);
    }
}