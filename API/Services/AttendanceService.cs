using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class AttendanceService : GenericService<Attendance>, IAttendanceService
    {
        private readonly IAttendanceRepository _attendanceRepository;
        private readonly IQRCodeRepository _qrCodeRepository;
        private readonly IStudentRepository _studentRepository;

        public AttendanceService(
            IAttendanceRepository attendanceRepository,
            IQRCodeRepository qrCodeRepository,
            IStudentRepository studentRepository,
            IUnitOfWork unitOfWork)
            : base(attendanceRepository, unitOfWork)
        {
            _attendanceRepository = attendanceRepository;
            _qrCodeRepository = qrCodeRepository;
            _studentRepository = studentRepository;
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByStudentAsync(int studentId)
        {
            return await _attendanceRepository.GetAttendancesByStudentAsync(studentId);
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByScheduleAsync(int scheduleId)
        {
            return await _attendanceRepository.GetAttendancesByScheduleAsync(scheduleId);
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByQRCodeAsync(int qrCodeId)
        {
            return await _attendanceRepository.GetAttendancesByQRCodeAsync(qrCodeId);
        }

        public async Task<IEnumerable<Attendance>> GetAttendancesByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            return await _attendanceRepository.GetAttendancesByDateRangeAsync(startDate, endDate);
        }
        
        public async Task<IEnumerable<Attendance>> GetAttendancesByTodayAsync()
        {
            return await _attendanceRepository.GetAttendancesByTodayAsync(DateTime.Today);
        }

        public async Task<bool> IsAttendanceUniqueAsync(int studentId, int scheduleId, DateTime attendanceDate)
        {
            return await _attendanceRepository.IsAttendanceUniqueAsync(studentId, scheduleId, attendanceDate);
        }

        public async Task<bool> MarkAttendanceAsync(int studentId, string qrCodeValue)
        {
            var qrCode = await _qrCodeRepository.GetQRCodeByValueAsync(qrCodeValue);
            if (qrCode == null || !qrCode.IsActive || qrCode.ExpiresAt < DateTime.UtcNow)
                return false;

            var student = await _studentRepository.GetStudentWithStudentIdAsync(studentId);
            if (student == null || !student.User.IsActive)
                return false;

            if (!await IsAttendanceUniqueAsync(studentId, qrCode.ScheduleId, DateTime.UtcNow))
                return false;

            var attendance = new Attendance
            {
                StudentId = studentId,
                QRCodeId = qrCode.Id,
                AttendanceDate = DateTime.UtcNow
            };

            await _attendanceRepository.AddAsync(attendance);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<Attendance>> GetStudentAttendanceReportAsync(int studentId, DateTime startDate, DateTime endDate)
        {
            var attendances = await _attendanceRepository.GetAttendancesByStudentAsync(studentId);
            return attendances.Where(a => a.AttendanceDate >= startDate && a.AttendanceDate <= endDate);
        }
    }
}