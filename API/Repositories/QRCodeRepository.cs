using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class QRCodeRepository : GenericRepository<QRCode>, IQRCodeRepository
    {
        public QRCodeRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<QRCode?> GetQRCodeByValueAsync(string qrCodeValue)
        {
            return await _dbSet
                .Include(q => q.Doctor)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Course)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Subject)
                .FirstOrDefaultAsync(q => q.QRCodeValue == qrCodeValue);
        }

        public async Task<IEnumerable<QRCode>> GetQRCodesByDoctorAsync(int doctorId)
        {
            return await _dbSet
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Course)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Subject)
                .Where(q => q.DoctorId == doctorId)
                .ToListAsync();
        }

        public async Task<IEnumerable<QRCode>> GetQRCodesByScheduleAsync(int scheduleId)
        {
            return await _dbSet
                .Include(q => q.Doctor)
                .Where(q => q.ScheduleId == scheduleId)
                .ToListAsync();
        }

        public async Task<IEnumerable<QRCode>> GetActiveQRCodesAsync()
        {
            return await _dbSet
                .Include(q => q.Doctor)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Course)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Subject)
                .Where(q => q.IsActive)
                .ToListAsync();
        }

        public async Task<bool> IsQRCodeValueUniqueAsync(string qrCodeValue)
        {
            return !await _dbSet.AnyAsync(q => q.QRCodeValue == qrCodeValue);
        }

        public async Task<IEnumerable<QRCode>> GetExpiredQRCodesAsync()
        {
            return await _dbSet
                .Include(q => q.Doctor)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Course)
                .Include(q => q.LectureSchedule)
                    .ThenInclude(ls => ls.CourseSubject)
                        .ThenInclude(cs => cs.Subject)
                .Where(q => q.ExpiresAt < DateTime.UtcNow)
                .ToListAsync();
        }
    }
}