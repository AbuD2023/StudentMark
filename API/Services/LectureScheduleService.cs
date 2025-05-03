using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class LectureScheduleService : GenericService<LectureSchedule>, ILectureScheduleService
    {
        private readonly ILectureScheduleRepository _lectureScheduleRepository;
        private readonly IQRCodeRepository _qrCodeRepository;
        private readonly IAttendanceRepository _attendanceRepository;

        public LectureScheduleService(
            ILectureScheduleRepository lectureScheduleRepository,
            IQRCodeRepository qrCodeRepository,
            IAttendanceRepository attendanceRepository,
            IUnitOfWork unitOfWork)
            : base(lectureScheduleRepository, unitOfWork)
        {
            _lectureScheduleRepository = lectureScheduleRepository;
            _qrCodeRepository = qrCodeRepository;
            _attendanceRepository = attendanceRepository;
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDoctorAsync(int doctorId)
        {
            return await _lectureScheduleRepository.GetSchedulesByDoctorAsync(doctorId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseSubjectAsync(int courseSubjectId)
        {
            return await _lectureScheduleRepository.GetSchedulesByCourseSubjectAsync(courseSubjectId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDepartmentAsync(int departmentId)
        {
            return await _lectureScheduleRepository.GetSchedulesByDepartmentAsync(departmentId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByLevelAsync(int levelId)
        {
            return await _lectureScheduleRepository.GetSchedulesByLevelAsync(levelId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetActiveSchedulesAsync()
        {
            return await _lectureScheduleRepository.GetActiveSchedulesAsync();
        }

        public async Task<bool> IsTimeSlotAvailableAsync(int doctorId, DayOfWeek dayOfWeek, TimeSpan startTime, TimeSpan endTime)
        {
            return await _lectureScheduleRepository.IsTimeSlotAvailableAsync(doctorId, dayOfWeek, startTime, endTime);
        }

        public async Task<IEnumerable<QRCode>> GetScheduleQRCodesAsync(int scheduleId)
        {
            return await _qrCodeRepository.GetQRCodesByScheduleAsync(scheduleId);
        }

        public async Task<IEnumerable<Attendance>> GetScheduleAttendancesAsync(int scheduleId)
        {
            return await _attendanceRepository.GetAttendancesByScheduleAsync(scheduleId);
        }
    }
}