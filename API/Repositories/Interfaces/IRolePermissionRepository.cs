using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IRolePermissionRepository : IGenericRepository<RolePermission>
    {
        Task<IEnumerable<RolePermission>> GetPermissionsByRoleAsync(int roleId);
        Task<IEnumerable<RolePermission>> GetRolesByPermissionAsync(int permissionId);
        Task<bool> IsRolePermissionUniqueAsync(int roleId, int permissionId);
    }
}