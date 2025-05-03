using API.Entities;

namespace API.Services.Interfaces
{
    public interface IStudentService : IGenericService<Student>
    {
        Task<Student?> GetStudentWithUserAsync(int studentId);
        Task<IEnumerable<Student>> GetStudentsByDepartmentAsync(int departmentId);
        Task<IEnumerable<Student>> GetStudentsByLevelAsync(int levelId);
        Task<IEnumerable<Student>> GetActiveStudentsAsync();
        Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear);
        Task<IEnumerable<Attendance>> GetStudentAttendancesAsync(int studentId);
        Task<IEnumerable<LectureSchedule>> GetStudentSchedulesAsync(int studentId);
    }
}