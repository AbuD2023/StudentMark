using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class LevelRepository : GenericRepository<Level>, ILevelRepository
    {
        public LevelRepository(ApplicationDbContext context) : base(context)
        {
        }

        
        public virtual async Task<IEnumerable<Level>> GetAllAsyncCopy()
        {
            return await _dbSet.Include(le=> le.Department).ToListAsync();
        }

        public async Task<IEnumerable<Level>> GetLevelsByDepartmentAsync(int departmentId)
        {
            return await _dbSet.Where(l => l.DepartmentId == departmentId).ToListAsync();
        }

        public async Task<IEnumerable<Level>> GetActiveLevelsAsync()
        {
            return await _dbSet.Where(l => l.IsActive).Include(le=> le.Department).ToListAsync();
        }

        public async Task<bool> IsLevelNameUniqueInDepartmentAsync(string levelName, int departmentId)
        {
            return !await _dbSet.AnyAsync(l =>
                l.LevelName.ToLower() == levelName.ToLower() &&
                l.DepartmentId == departmentId);
        }

        public async Task<Level?> GetByNameAsync(string levelName)
        {
            return await _dbSet.FirstOrDefaultAsync(l => l.LevelName == levelName);
        }
    }
}