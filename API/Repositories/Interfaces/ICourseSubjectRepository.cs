using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface ICourseSubjectRepository : IGenericRepository<CourseSubject>
    {
        Task<IEnumerable<CourseSubject>> GetCourseSubjectsByCourseAsync(int courseId);
        Task<IEnumerable<CourseSubject>> GetCourseSubjectsBySubjectAsync(int subjectId);
        Task<IEnumerable<CourseSubject>> GetCourseSubjectsByLevelAsync(int levelId);
        Task<bool> IsCourseSubjectUniqueAsync(int courseId, int subjectId, int levelId);
    }
}