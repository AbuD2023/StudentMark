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

        public async Task<Student?> GetStudentWithStudentIdAsync(int studentId)
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .FirstOrDefaultAsync(s => s.Id == studentId);
        }
        
        public async Task<Student?> GetStudentWithUserIdAsync(int userId)
        {
            return await _dbSet
                .Where(s => s.UserId == userId).FirstOrDefaultAsync();
        }
        
        public async Task<bool> StudentIsActive(int userId)
        {
            Student? student = await _dbSet
                .Where(s => s.UserId == userId && s.IsActive).FirstOrDefaultAsync();

            if (student == null)
            {
                return false;
            }
            return true;
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
                .Where(s => s.IsActive)
                .ToListAsync();
        }
        
        public async Task<IEnumerable<Student>> GetAllStudentAsync()
        {
            return await _dbSet
                .Include(s => s.User)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public Task<bool> IsEnrollmentYearValidAsync(int enrollmentYear)
        {
            return Task.FromResult(enrollmentYear >= DateTime.Now.Year - 4 && enrollmentYear <= DateTime.Now.Year);
        }
        
        public async Task<bool> IsAcademicIdValidAsync(string AcademicId)
        {
          Student? student = await _dbSet.Where(st => st.AcademicId == AcademicId).FirstOrDefaultAsync();
            if(student == null)
            {
                return false;
            }
            return true;
        }
    }
}