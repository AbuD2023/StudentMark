using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class PermissionRepository : GenericRepository<Permission>, IPermissionRepository
    {
        public PermissionRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Permission>> GetPermissionsByModuleAsync(string module)
        {
            return await _dbSet.Where(p => p.Module == module).ToListAsync();
        }

        public async Task<IEnumerable<Permission>> GetPermissionsByRoleAsync(int roleId)
        {
            return await _dbSet
                .Include(p => p.RolePermissions)
                .Where(p => p.RolePermissions.Any(rp => rp.RoleId == roleId))
                .ToListAsync();
        }

        public async Task<bool> IsPermissionNameUniqueAsync(string permissionName)
        {
            return !await _dbSet.AnyAsync(p => p.Name == permissionName);
        }
    }
}
