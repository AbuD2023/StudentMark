using API.Entities;

namespace API.Services.Interfaces
{
    public interface IPermissionService : IGenericService<Permission>
    {
        Task<IEnumerable<Permission>> GetPermissionsByModuleAsync(string module);
        Task<IEnumerable<Permission>> GetPermissionsByRoleAsync(int roleId);
        Task<bool> IsPermissionNameUniqueAsync(string permissionName);
    }
}