using API.Data;
using API.Repositories.Interfaces;

namespace API.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly ApplicationDbContext _context;
        private IUserRepository _userRepository;
        private IRoleRepository _roleRepository;
        private IPermissionRepository _permissionRepository;
        private IDepartmentRepository _departmentRepository;
        private ILevelRepository _levelRepository;
        private ICourseRepository _courseRepository;
        private ISubjectRepository _subjectRepository;
        private ICourseSubjectRepository _courseSubjectRepository;
        private ILectureScheduleRepository _lectureScheduleRepository;
        private IStudentRepository _studentRepository;
        private IQRCodeRepository _qrCodeRepository;
        private IAttendanceRepository _attendanceRepository;
        private IDoctorDepartmentsLevelsRepository _doctorDepartmentsLevelsRepository;

        public UnitOfWork(ApplicationDbContext context)
        {
            _context = context;
        }

        public IUserRepository Users => _userRepository ??= new UserRepository(_context);
        public IRoleRepository Roles => _roleRepository ??= new RoleRepository(_context);
        public IPermissionRepository Permissions => _permissionRepository ??= new PermissionRepository(_context);
        public IDepartmentRepository Departments => _departmentRepository ??= new DepartmentRepository(_context);
        public ILevelRepository Levels => _levelRepository ??= new LevelRepository(_context);
        public ICourseRepository Courses => _courseRepository ??= new CourseRepository(_context);
        public ISubjectRepository Subjects => _subjectRepository ??= new SubjectRepository(_context);
        public ICourseSubjectRepository CourseSubjects => _courseSubjectRepository ??= new CourseSubjectRepository(_context);
        public ILectureScheduleRepository LectureSchedules => _lectureScheduleRepository ??= new LectureScheduleRepository(_context);
        public IStudentRepository Students => _studentRepository ??= new StudentRepository(_context);
        public IQRCodeRepository QRCodes => _qrCodeRepository ??= new QRCodeRepository(_context);
        public IAttendanceRepository Attendances => _attendanceRepository ??= new AttendanceRepository(_context);
        public IDoctorDepartmentsLevelsRepository DoctorDepartmentsLevels => _doctorDepartmentsLevelsRepository ??= new DoctorDepartmentsLevelsRepository(_context);

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }

        public void Dispose()
        {
            _context.Dispose();
        }
    }
}