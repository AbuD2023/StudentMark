using API.Entities;

namespace API.Services.Interfaces
{
    public interface IStudentService : IGenericService<Student>
    {
        Task<Student?> GetStudentWithStudentIdAsync(int studentId);
        Task<Student?> GetStudentWithUserIdAsync(int userId);
        Task<IEnumerable<Student>> GetStudentsByDepartmentAsync(int departmentId);
        Task<IEnumerable<Student>> GetStudentsByLevelAsync(int levelId);
        Task<IEnumerable<Student>> GetActiveStudentsAsync();
        Task<IEnumerable<Student>> GetAllStudentAsync();
        Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear);
        Task<bool> IsAcademicIdValidAsync(string AcademicId);
        Task<IEnumerable<Attendance>> GetStudentAttendancesAsync(int studentId);
        Task<IEnumerable<LectureSchedule>> GetStudentSchedulesAsync(int studentId);
    }
}