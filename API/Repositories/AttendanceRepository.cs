using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class AttendanceRepository : GenericRepository<Attendance>, IAttendanceRepository
    {
        public AttendanceRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByStudentAsync(int studentId)
        {
            return await _dbSet
                .Include(a => a.Student)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                .Where(a => a.StudentId == studentId)
                .ToListAsync();
        }
        
        public async Task<IEnumerable<Attendance>> GetAttendancesByDoctorAsync(int doctorId)
        {
            return await _dbSet
                .Include(a => a.Student)
                    .ThenInclude(q => q.User)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(q => q.Doctor)
                //.Include(a => a.LectureSchedule)
                //    .ThenInclude(ls => ls.CourseSubject)
                //            .ThenInclude(cs => cs.Course)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(ls => ls.Department)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(ls => ls.Level)
                .Where(a => a.LectureSchedule.Doctor.Id == doctorId)
                .ToListAsync();
        }
        
        public async Task<IEnumerable<Attendance>> GetAttendancesByTodayAsync(DateTime todayDate)
        {
            return await _dbSet
                .Include(a => a.Student)
                    .ThenInclude(q => q.User)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(q => q.Doctor)
                //.Include(a => a.LectureSchedule)
                //    .ThenInclude(ls => ls.CourseSubject)
                //            .ThenInclude(cs => cs.Course)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(ls => ls.Department)
                .Include(a => a.LectureSchedule)
                    .ThenInclude(ls => ls.Level)
                .Where(a => a.AttendanceDate.Date == todayDate.Date)
                .ToListAsync();
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByScheduleAsync(int scheduleId)
        {
            return await _dbSet
                .Include(a => a.Student)
                    .ThenInclude(q => q.User)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                .Where(a => a.QRCode.ScheduleId == scheduleId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByQRCodeAsync(int qrCodeId)
        {
            return await _dbSet
                .Include(a => a.Student)
                .ThenInclude(q => q.User)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                            .Include(a => a.LectureSchedule)
.ThenInclude(q => q.Doctor)
                .Where(a => a.QRCodeId == qrCodeId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            return await _dbSet
                .Include(a => a.Student)
                    .ThenInclude(q => q.User)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Course)
                .Include(a => a.QRCode)
                    .ThenInclude(q => q.LectureSchedule)
                        .ThenInclude(ls => ls.CourseSubject)
                            .ThenInclude(cs => cs.Subject)
                    .Include(a => a.LectureSchedule)
                    .ThenInclude(q => q.Doctor)
                .Where(a => a.AttendanceDate >= startDate && a.AttendanceDate <= endDate)
                .ToListAsync();
        }

        public async Task<bool> IsAttendanceUniqueAsync(int studentId, int scheduleId, DateTime attendanceDate)
        {
            return !await _dbSet.AnyAsync(a =>
                a.StudentId == studentId &&
                a.QRCode.ScheduleId == scheduleId &&
                a.AttendanceDate.Date == attendanceDate.Date);
        }
    }
}