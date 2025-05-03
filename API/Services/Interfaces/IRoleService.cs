using API.Entities;

namespace API.Services.Interfaces
{
    public interface IRoleService : IGenericService<Role>
    {
        Task<Role?> GetRoleWithPermissionsAsync(int roleId);
        Task<IEnumerable<Role>> GetActiveRolesAsync();
        Task<bool> IsRoleNameUniqueAsync(string roleName);
        Task<bool> AssignPermissionToRoleAsync(int roleId, int permissionId);
        Task<bool> RemovePermissionFromRoleAsync(int roleId, int permissionId);
    }
}