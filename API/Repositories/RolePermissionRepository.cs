using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class RolePermissionRepository : GenericRepository<RolePermission>, IRolePermissionRepository
    {
        public RolePermissionRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<RolePermission>> GetPermissionsByRoleAsync(int roleId)
        {
            return await _context.RolePermissions
                .Include(rp => rp.Permission)
                .Where(rp => rp.RoleId == roleId)
                .ToListAsync();
        }

        public async Task<IEnumerable<RolePermission>> GetRolesByPermissionAsync(int permissionId)
        {
            return await _context.RolePermissions
                .Include(rp => rp.Role)
                .Where(rp => rp.PermissionId == permissionId)
                .ToListAsync();
        }

        public async Task<bool> IsRolePermissionUniqueAsync(int roleId, int permissionId)
        {
            return !await _context.RolePermissions
                .AnyAsync(rp => rp.RoleId == roleId && rp.PermissionId == permissionId);
        }
    }
}