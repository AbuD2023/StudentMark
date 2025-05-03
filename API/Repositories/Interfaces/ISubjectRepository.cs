using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface ISubjectRepository : IGenericRepository<Subject>
    {
        Task<Subject?> GetSubjectWithCoursesAsync(int subjectId);
        Task<IEnumerable<Subject>> GetActiveSubjectsAsync();
        Task<bool> IsSubjectNameUniqueAsync(string subjectName);
    }
}