using API.Entities;

namespace API.Services.Interfaces
{
    public interface ILevelService : IGenericService<Level>
    {
        Task<IEnumerable<Level>> GetLevelsByDepartmentAsync(int departmentId);
        Task<IEnumerable<Level>> GetActiveLevelsAsync();
        Task<IEnumerable<Level>> GetAllAsyncCopy();
        Task<bool> IsLevelNameUniqueInDepartmentAsync(string levelName, int departmentId);
        Task<IEnumerable<Course>> GetLevelCoursesAsync(int levelId);
        Task<IEnumerable<Student>> GetLevelStudentsAsync(int levelId);
        Task<Level?> GetByNameAsync(string levelName);
    }
}