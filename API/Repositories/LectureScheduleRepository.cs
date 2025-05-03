using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class LectureScheduleRepository : GenericRepository<LectureSchedule>, ILectureScheduleRepository
    {
        public LectureScheduleRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDoctorAsync(int doctorId)
        {
            return await _context.LectureSchedules
                .Where(s => s.DoctorId == doctorId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseSubjectAsync(int courseSubjectId)
        {
            return await _context.LectureSchedules
                .Where(s => s.CourseSubjectId == courseSubjectId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseAsync(int courseId)
        {
            return await _context.LectureSchedules
                .Where(s => s.CourseSubject.CourseId == courseId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDepartmentAsync(int departmentId)
        {
            return await _context.LectureSchedules
                .Where(s => s.DepartmentId == departmentId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByLevelAsync(int levelId)
        {
            return await _context.LectureSchedules
                .Where(s => s.LevelId == levelId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.LectureSchedules
                .Where(s => s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetActiveSchedulesAsync()
        {
            return await _context.LectureSchedules
                .Where(s => s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<bool> IsTimeSlotAvailableAsync(int doctorId, DayOfWeek dayOfWeek, TimeSpan startTime, TimeSpan endTime)
        {
            return !await _context.LectureSchedules
                .AnyAsync(s => s.DoctorId == doctorId &&
                              s.DayOfWeek == dayOfWeek &&
                              s.IsActive &&
                              ((s.StartTime <= startTime && s.EndTime > startTime) ||
                               (s.StartTime < endTime && s.EndTime >= endTime) ||
                               (s.StartTime >= startTime && s.EndTime <= endTime)));
        }
    }
}