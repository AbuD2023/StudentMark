using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class StudentService : GenericService<Student>, IStudentService
    {
        private readonly IStudentRepository _studentRepository;
        private readonly IAttendanceRepository _attendanceRepository;
        private readonly ILectureScheduleRepository _lectureScheduleRepository;

        public StudentService(
            IStudentRepository studentRepository,
            IAttendanceRepository attendanceRepository,
            ILectureScheduleRepository lectureScheduleRepository,
            IUnitOfWork unitOfWork)
            : base(studentRepository, unitOfWork)
        {
            _studentRepository = studentRepository;
            _attendanceRepository = attendanceRepository;
            _lectureScheduleRepository = lectureScheduleRepository;
        }

        public async Task<Student?> GetStudentWithStudentIdAsync(int studentId)
        {
            return await _studentRepository.GetStudentWithStudentIdAsync(studentId);
        }
        public async Task<Student?> GetStudentWithUserIdAsync(int userId)
        {
            return await _studentRepository.GetStudentWithStudentIdAsync(userId);
        }
        
        public async Task<bool> StudentIsActive(int userId)
        {
            return await _studentRepository.StudentIsActive(userId);
        }

        public async Task<IEnumerable<Student>> GetStudentsByDepartmentAsync(int departmentId)
        {
            return await _studentRepository.GetStudentsByDepartmentAsync(departmentId);
        }

        public async Task<IEnumerable<Student>> GetStudentsByLevelAsync(int levelId)
        {
            return await _studentRepository.GetStudentsByLevelAsync(levelId);
        }

        public async Task<IEnumerable<Student>> GetActiveStudentsAsync()
        {
            return await _studentRepository.GetActiveStudentsAsync();
        }
        
        public async Task<IEnumerable<Student>> GetAllStudentAsync()
        {
            return await _studentRepository.GetAllStudentAsync();
        }

        public async Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear)
        {
            return await _studentRepository.IsEnrollmentYearValidAsync(enrollmentYear);
        }
        
        public async Task<bool> IsAcademicIdValidAsync(string AcademicId)
        {
            return await _studentRepository.IsAcademicIdValidAsync(AcademicId);
        }

        public async Task<IEnumerable<Attendance>> GetStudentAttendancesAsync(int studentId)
        {
            return await _attendanceRepository.GetAttendancesByStudentAsync(studentId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetStudentSchedulesAsync(int studentId)
        {
            var student = await _studentRepository.GetStudentWithStudentIdAsync(studentId);
            if (student == null)
                return Enumerable.Empty<LectureSchedule>();

            return await _lectureScheduleRepository.GetSchedulesByLevelAsync(student.LevelId);
        }
    }
}