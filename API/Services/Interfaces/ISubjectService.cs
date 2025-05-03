using API.Entities;

namespace API.Services.Interfaces
{
    public interface ISubjectService : IGenericService<Subject>
    {
        Task<Subject?> GetSubjectWithCoursesAsync(int subjectId);
        Task<IEnumerable<Subject>> GetActiveSubjectsAsync();
        Task<bool> IsSubjectNameUniqueAsync(string subjectName);
        Task<IEnumerable<Course>> GetSubjectCoursesAsync(int subjectId);
        Task<IEnumerable<LectureSchedule>> GetSubjectSchedulesAsync(int subjectId);
    }
}