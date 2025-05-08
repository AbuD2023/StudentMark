using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface ICourseRepository : IGenericRepository<Course>
    {
        Task<IEnumerable<Course>> GetCoursesByDepartmentAsync(int departmentId);
        Task<Course?> GetCourseWithSubjectsAsync(int courseId);
        Task<IEnumerable<Course>> GetActiveCoursesAsync();
        Task<IEnumerable<Course>> GetAllCoursesAsync();
        Task<bool> IsCourseNameUniqueInDepartmentAsync(string courseName, int departmentId);
        Task<IEnumerable<Course>> GetCoursesByLevelAsync(int levelId);
    }
}