using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class CourseSubjectRepository : GenericRepository<CourseSubject>, ICourseSubjectRepository
    {
        public CourseSubjectRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsByCourseAsync(int courseId)
        {
            return await _dbSet
                .Include(cs => cs.Subject)
                .Include(cs => cs.Level)
                .Where(cs => cs.CourseId == courseId)
                .ToListAsync();
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsBySubjectAsync(int subjectId)
        {
            return await _dbSet
                .Include(cs => cs.Course)
                .Include(cs => cs.Level)
                .Where(cs => cs.SubjectId == subjectId)
                .ToListAsync();
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsByLevelAsync(int levelId)
        {
            return await _dbSet
                .Include(cs => cs.Course)
                .Include(cs => cs.Subject)
                .Where(cs => cs.LevelId == levelId)
                .ToListAsync();
        }

        public async Task<bool> IsCourseSubjectUniqueAsync(int courseId, int subjectId, int levelId)
        {
            return !await _dbSet.AnyAsync(cs => 
                cs.CourseId == courseId && 
                cs.SubjectId == subjectId && 
                cs.LevelId == levelId);
        }
    }
} 