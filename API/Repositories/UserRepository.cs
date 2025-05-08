using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class UserRepository : GenericRepository<User>, IUserRepository
    {
        public UserRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<User?> GetByEmailAsync(string email)
        {
            return await _dbSet.FirstOrDefaultAsync(u => u.Email == email);
        }

        public async Task<IEnumerable<User>> GetUsersByRoleAsync(int roleId)
        {
            return await _dbSet.Where(u => u.RoleId == roleId).ToListAsync();
        }

        public async Task<bool> IsEmailUniqueAsync(string email)
        {
            return !await _dbSet.AnyAsync(u => u.Email == email);
        }

        public async Task<User> GetUserWithRoleAsync(string username)
        {
            return await _context.Users
                .Include(u => u.Role)
                    .ThenInclude(r => r.RolePermissions)
                        .ThenInclude(rp => rp.Permission)
                .FirstOrDefaultAsync(u => u.Username == username);
        }

        public async Task<IEnumerable<User>> GetActiveUsersAsync()
        {
            return await _dbSet.Where(u => u.IsActive).Include(u=> u.Role).ThenInclude(r=> r.RolePermissions).ThenInclude(rp=> rp.Permission).ToListAsync();
        }
        
        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            return await _dbSet.Include(u => u.Student).Include(u=> u.Role).ThenInclude(r=> r.RolePermissions).ThenInclude(rp=> rp.Permission).ToListAsync();
        }
        public async Task<IEnumerable<User>> GetUsersByRoleIdAsync(int RoleId)
        {
            return await _dbSet.Where(u => u.RoleId == RoleId).ToListAsync();
        }

        public async Task<bool> IsUsernameUniqueAsync(string username)
        {
            return await _context.Users.AnyAsync(u => u.Username == username);
        }

        public async Task<IEnumerable<User>> GetUnassignedDoctors()
        {
            var allDoctors = await _context.Users
                .Where(u => u.RoleId == 2) // RoleId 2 is for Doctor role
                .ToListAsync();

            var assignedDoctors = await _context.DoctorDepartmentsLevels
                .Select(d => d.DoctorId)
                .Distinct()
                .ToListAsync();

            return allDoctors.Where(d => !assignedDoctors.Contains(d.Id));
        }
    }
}