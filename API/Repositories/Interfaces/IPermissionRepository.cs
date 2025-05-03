using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IPermissionRepository : IGenericRepository<Permission>
    {
        Task<IEnumerable<Permission>> GetPermissionsByModuleAsync(string module);
        Task<IEnumerable<Permission>> GetPermissionsByRoleAsync(int roleId);
        Task<bool> IsPermissionNameUniqueAsync(string permissionName);
    }
}