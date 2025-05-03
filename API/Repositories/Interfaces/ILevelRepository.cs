using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface ILevelRepository : IGenericRepository<Level>
    {
        Task<IEnumerable<Level>> GetLevelsByDepartmentAsync(int departmentId);
        Task<IEnumerable<Level>> GetAllAsyncCopy();
        Task<IEnumerable<Level>> GetActiveLevelsAsync();
        Task<bool> IsLevelNameUniqueInDepartmentAsync(string levelName, int departmentId);
        Task<Level?> GetByNameAsync(string levelName);
    }
}