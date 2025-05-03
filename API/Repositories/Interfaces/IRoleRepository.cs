using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IRoleRepository : IGenericRepository<Role>
    {
        Task<Role?> GetRoleWithPermissionsAsync(int roleId);
        Task<IEnumerable<Role>> GetActiveRolesAsync();
        Task<bool> IsRoleNameUniqueAsync(string roleName);
    }
}