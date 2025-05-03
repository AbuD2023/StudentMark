using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class CourseSubjectService : GenericService<CourseSubject>, ICourseSubjectService
    {
        private readonly ICourseSubjectRepository _courseSubjectRepository;
        private readonly ILectureScheduleRepository _lectureScheduleRepository;

        public CourseSubjectService(
            ICourseSubjectRepository courseSubjectRepository,
            ILectureScheduleRepository lectureScheduleRepository,
            IUnitOfWork unitOfWork)
            : base(courseSubjectRepository, unitOfWork)
        {
            _courseSubjectRepository = courseSubjectRepository;
            _lectureScheduleRepository = lectureScheduleRepository;
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsByCourseAsync(int courseId)
        {
            return await _courseSubjectRepository.GetCourseSubjectsByCourseAsync(courseId);
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsBySubjectAsync(int subjectId)
        {
            return await _courseSubjectRepository.GetCourseSubjectsBySubjectAsync(subjectId);
        }

        public async Task<IEnumerable<CourseSubject>> GetCourseSubjectsByLevelAsync(int levelId)
        {
            return await _courseSubjectRepository.GetCourseSubjectsByLevelAsync(levelId);
        }

        public async Task<bool> IsCourseSubjectUniqueAsync(int courseId, int subjectId, int levelId)
        {
            return await _courseSubjectRepository.IsCourseSubjectUniqueAsync(courseId, subjectId, levelId);
        }

        public async Task<IEnumerable<LectureSchedule>> GetCourseSubjectSchedulesAsync(int courseSubjectId)
        {
            return await _lectureScheduleRepository.GetSchedulesByCourseSubjectAsync(courseSubjectId);
        }
    }
}