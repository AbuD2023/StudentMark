using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class RoleRepository : GenericRepository<Role>, IRoleRepository
    {
        public RoleRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<Role?> GetRoleWithPermissionsAsync(int roleId)
        {
            return await _dbSet
                .Include(r => r.RolePermissions)
                    .ThenInclude(rp => rp.Permission)
                .FirstOrDefaultAsync(r => r.Id == roleId);
        }

        public async Task<IEnumerable<Role>> GetActiveRolesAsync()
        {
            return await _dbSet.Where(r => r.Users.Any(u => u.IsActive)).ToListAsync();
        }

        public async Task<bool> IsRoleNameUniqueAsync(string roleName)
        {
            return !await _dbSet.AnyAsync(r => r.Name == roleName);
        }
    }
}