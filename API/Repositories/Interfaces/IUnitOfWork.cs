namespace API.Repositories.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        IUserRepository Users { get; }
        IRoleRepository Roles { get; }
        IPermissionRepository Permissions { get; }
        IDepartmentRepository Departments { get; }
        ILevelRepository Levels { get; }
        ICourseRepository Courses { get; }
        ISubjectRepository Subjects { get; }
        ICourseSubjectRepository CourseSubjects { get; }
        ILectureScheduleRepository LectureSchedules { get; }
        IStudentRepository Students { get; }
        IQRCodeRepository QRCodes { get; }
        IAttendanceRepository Attendances { get; }
        IDoctorDepartmentsLevelsRepository DoctorDepartmentsLevels { get; }
        Task<int> SaveChangesAsync();
    }
}