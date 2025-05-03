using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class DepartmentRepository : GenericRepository<Department>, IDepartmentRepository
    {
        public DepartmentRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<Department?> GetDepartmentWithLevelsAsync(int departmentId)
        {
            return await _dbSet
                .Include(d => d.Levels)
                .FirstOrDefaultAsync(d => d.Id == departmentId);
        }

        public async Task<IEnumerable<Department>> GetActiveDepartmentsAsync()
        {
            return await _dbSet.Where(d => d.IsActive).ToListAsync();
        }

        public async Task<bool> IsDepartmentNameUniqueAsync(string departmentName)
        {
            return !await _dbSet.AnyAsync(d => d.DepartmentName == departmentName);
        }

        public async Task<Department?> GetByNameAsync(string departmentName)
        {
            return await _dbSet.FirstOrDefaultAsync(d => d.DepartmentName == departmentName);
        }
    }
}