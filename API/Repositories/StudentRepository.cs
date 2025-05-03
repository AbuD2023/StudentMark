using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class StudentRepository : GenericRepository<Student>, IStudentRepository
    {
        public StudentRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<Student?> GetStudentWithUserAsync(int studentId)
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .FirstOrDefaultAsync(s => s.Id == studentId);
        }

        public async Task<IEnumerable<Student>> GetStudentsByDepartmentAsync(int departmentId)
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Level)
                .Where(s => s.DepartmentId == departmentId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Student>> GetStudentsByLevelAsync(int levelId)
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Department)
                .Where(s => s.LevelId == levelId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Student>> GetStudentsByLevelAndDepartmentAsync(int levelId, int departmentId)
        {
            return await _dbSet
                .Include(s => s.User)
                .Where(s => s.LevelId == levelId && s.DepartmentId == departmentId)
                .ToListAsync();
        }

        public async Task<IEnumerable<Student>> GetActiveStudentsAsync()
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .Where(s => s.User.IsActive)
                .ToListAsync();
        }

        public async Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear)
        {
            return enrollmentYear >= DateTime.Now.Year - 4 && enrollmentYear <= DateTime.Now.Year;
        }
    }
}