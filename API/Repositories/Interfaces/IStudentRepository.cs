using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IStudentRepository : IGenericRepository<Student>
    {
        Task<Student?> GetStudentWithUserAsync(int studentId);
        Task<IEnumerable<Student>> GetStudentsByDepartmentAsync(int departmentId);
        Task<IEnumerable<Student>> GetStudentsByLevelAsync(int levelId);
        Task<IEnumerable<Student>> GetStudentsByLevelAndDepartmentAsync(int levelId, int departmentId);
        Task<IEnumerable<Student>> GetActiveStudentsAsync();
        Task<IEnumerable<Student>> GetAllStudentAsync();
        Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear);
    }
}