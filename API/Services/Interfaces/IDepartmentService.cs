using API.Entities;

namespace API.Services.Interfaces
{
    public interface IDepartmentService : IGenericService<Department>
    {
        Task<Department?> GetDepartmentWithLevelsAsync(int departmentId);
        Task<IEnumerable<Department>> GetActiveDepartmentsAsync();
        Task<bool> IsDepartmentNameUniqueAsync(string departmentName);
        Task<IEnumerable<Course>> GetDepartmentCoursesAsync(int departmentId);
        Task<IEnumerable<Student>> GetDepartmentStudentsAsync(int departmentId);
        Task<Department?> GetByNameAsync(string departmentName);
    }
}