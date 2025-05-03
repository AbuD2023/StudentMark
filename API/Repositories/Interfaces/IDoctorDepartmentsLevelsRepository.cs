using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IDoctorDepartmentsLevelsRepository : IGenericRepository<DoctorDepartmentsLevels>
    {
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByDoctorAsync(int doctorId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByDepartmentAsync(int departmentId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByLevelAsync(int levelId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetActiveAssignmentsAsync();
        Task<bool> IsAssignmentUniqueAsync(int doctorId, int departmentId, int levelId);
    }
}