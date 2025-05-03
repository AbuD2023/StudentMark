using API.Entities;

namespace API.Services.Interfaces
{
    public interface IDoctorDepartmentsLevelsService : IGenericService<DoctorDepartmentsLevels>
    {
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByDoctorAsync(int doctorId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByDepartmentAsync(int departmentId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetByLevelAsync(int levelId);
        Task<IEnumerable<DoctorDepartmentsLevels>> GetActiveAssignmentsAsync();
        Task<bool> IsAssignmentUniqueAsync(int doctorId, int departmentId, int levelId);
        Task<bool> AssignDoctorToDepartmentLevelAsync(int doctorId, int departmentId, int levelId);
        Task<bool> RemoveDoctorFromDepartmentLevelAsync(int doctorId, int departmentId, int levelId);
        Task<bool> AddToDepartmentAsync(int doctorId, int departmentId);
    }
}