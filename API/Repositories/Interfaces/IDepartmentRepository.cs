using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IDepartmentRepository : IGenericRepository<Department>
    {
        Task<Department?> GetDepartmentWithLevelsAsync(int departmentId);
        Task<IEnumerable<Department>> GetActiveDepartmentsAsync();
        Task<bool> IsDepartmentNameUniqueAsync(string departmentName);
        Task<Department?> GetByNameAsync(string departmentName);
        //Task<Department?> GetDepartmentWithLevelsAsync(int id);
    }
}