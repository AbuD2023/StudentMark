using API.Entities;

namespace API.Services.Interfaces
{
    public interface IRolePermissionService : IGenericService<RolePermission>
    {
        Task<IEnumerable<RolePermission>> GetPermissionsByRoleAsync(int roleId);
        Task<IEnumerable<RolePermission>> GetRolesByPermissionAsync(int permissionId);
        Task<bool> IsRolePermissionUniqueAsync(int roleId, int permissionId);
        Task AssignPermissionToRoleAsync(int roleId, int permissionId);
        Task RemovePermissionFromRoleAsync(int roleId, int permissionId);
        Task<bool> HasPermissionAsync(int roleId, string permissionName);
    }
}