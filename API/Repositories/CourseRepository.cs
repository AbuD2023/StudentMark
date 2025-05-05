using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class CourseRepository : GenericRepository<Course>, ICourseRepository
    {
        public CourseRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Course>> GetCoursesByDepartmentAsync(int departmentId)
        {
            return await _dbSet
                .Include(c => c.CourseSubjects)
                    .ThenInclude(cs => cs.Subject)
                .Include(c => c.Department)
                .Where(c => c.DepartmentId == departmentId)
                .ToListAsync();
        }

        public async Task<Course?> GetCourseWithSubjectsAsync(int courseId)
        {
            return await _dbSet
                .Include(c => c.CourseSubjects)
                    .ThenInclude(cs => cs.Subject)
                .Include(c => c.Department)
                .FirstOrDefaultAsync(c => c.Id == courseId);
        }

        public async Task<IEnumerable<Course>> GetActiveCoursesAsync()
        {
            return await _dbSet
                .Include(c => c.CourseSubjects)
                    .ThenInclude(cs => cs.Subject)
                .Include(c => c.Department)
                .Where(c => c.IsActive)
                .ToListAsync();
        }

        public async Task<bool> IsCourseNameUniqueInDepartmentAsync(string courseName, int departmentId)
        {
            return !await _dbSet.AnyAsync(c =>
                c.CourseName.ToLower() == courseName.ToLower() &&
                c.DepartmentId == departmentId);
        }

        public async Task<IEnumerable<Course>> GetCoursesByLevelAsync(int levelId)
        {
            return await _dbSet
                .Include(c => c.CourseSubjects)
                    .ThenInclude(cs => cs.Subject)
                .Include(c => c.Department)
                    .ThenInclude(cs => cs.LectureSchedules)
                .Include(c => c.LectureSchedules)
                .Where(c => c.CourseSubjects.Any(cs => cs.LevelId == levelId))
                .ToListAsync();
        }
    }
}