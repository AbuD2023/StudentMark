using API.Entities;

namespace API.Services.Interfaces
{
    public interface ICourseService : IGenericService<Course>
    {
        Task<IEnumerable<Course>> GetCoursesByDepartmentAsync(int departmentId);
        Task<Course?> GetCourseWithSubjectsAsync(int courseId);
        Task<IEnumerable<Course>> GetActiveCoursesAsync();
        Task<bool> IsCourseNameUniqueInDepartmentAsync(string courseName, int departmentId);
        Task<IEnumerable<Subject>> GetCourseSubjectsAsync(int courseId);
        Task<bool> AddSubjectToCourseAsync(int courseId, int subjectId, int levelId);
        Task<bool> RemoveSubjectFromCourseAsync(int courseId, int subjectId, int levelId);
        Task<IEnumerable<Course>> GetAllCoursesAsync();
    }
}