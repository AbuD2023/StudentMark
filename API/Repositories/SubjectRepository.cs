using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Repositories
{
    public class SubjectRepository : GenericRepository<Subject>, ISubjectRepository
    {
        public SubjectRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<Subject?> GetSubjectWithCoursesAsync(int subjectId)
        {
            return await _dbSet
                .Include(s => s.CourseSubjects)
                    .ThenInclude(cs => cs.Course)
                .FirstOrDefaultAsync(s => s.Id == subjectId);
        }

        public async Task<IEnumerable<Subject>> GetActiveSubjectsAsync()
        {
            return await _dbSet.Where(s => s.IsActive).ToListAsync();
        }

        public async Task<bool> IsSubjectNameUniqueAsync(string subjectName)
        {
            return !await _dbSet.AnyAsync(s => s.SubjectName == subjectName);
        }
    }
} 