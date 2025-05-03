using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class DoctorDepartmentsLevelsRepository : GenericRepository<DoctorDepartmentsLevels>, IDoctorDepartmentsLevelsRepository
    {
        public DoctorDepartmentsLevelsRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByDoctorAsync(int doctorId)
        {
            return await _dbSet
                .Include(ddl => ddl.Department)
                .Include(ddl => ddl.Level)
                .Where(ddl => ddl.DoctorId == doctorId)
                .ToListAsync();
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByDepartmentAsync(int departmentId)
        {
            return await _dbSet
                .Include(ddl => ddl.Doctor)
                .Include(ddl => ddl.Level)
                .Where(ddl => ddl.DepartmentId == departmentId)
                .ToListAsync();
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByLevelAsync(int levelId)
        {
            return await _dbSet
                .Include(ddl => ddl.Doctor)
                .Include(ddl => ddl.Department)
                .Where(ddl => ddl.LevelId == levelId)
                .ToListAsync();
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetActiveAssignmentsAsync()
        {
            return await _dbSet
                .Include(ddl => ddl.Doctor)
                .Include(ddl => ddl.Department)
                .Include(ddl => ddl.Level)
                .Where(ddl => ddl.IsActive)
                .ToListAsync();
        }

        public async Task<bool> IsAssignmentUniqueAsync(int doctorId, int departmentId, int levelId)
        {
            return !await _dbSet.AnyAsync(ddl =>
                ddl.DoctorId == doctorId &&
                ddl.DepartmentId == departmentId &&
                ddl.LevelId == levelId);
        }
    }
}