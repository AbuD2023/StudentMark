using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class SubjectService : GenericService<Subject>, ISubjectService
    {
        private readonly ISubjectRepository _subjectRepository;
        private readonly ICourseSubjectRepository _courseSubjectRepository;
        private readonly ILectureScheduleRepository _lectureScheduleRepository;

        public SubjectService(
            ISubjectRepository subjectRepository,
            ICourseSubjectRepository courseSubjectRepository,
            ILectureScheduleRepository lectureScheduleRepository,
            IUnitOfWork unitOfWork)
            : base(subjectRepository, unitOfWork)
        {
            _subjectRepository = subjectRepository;
            _courseSubjectRepository = courseSubjectRepository;
            _lectureScheduleRepository = lectureScheduleRepository;
        }

        public async Task<Subject?> GetSubjectWithCoursesAsync(int subjectId)
        {
            return await _subjectRepository.GetSubjectWithCoursesAsync(subjectId);
        }

        public async Task<IEnumerable<Subject>> GetActiveSubjectsAsync()
        {
            return await _subjectRepository.GetActiveSubjectsAsync();
        }

        public async Task<bool> IsSubjectNameUniqueAsync(string subjectName)
        {
            return await _subjectRepository.IsSubjectNameUniqueAsync(subjectName);
        }

        public async Task<IEnumerable<Course>> GetSubjectCoursesAsync(int subjectId)
        {
            var courseSubjects = await _courseSubjectRepository.GetCourseSubjectsBySubjectAsync(subjectId);
            return courseSubjects.Select(cs => cs.Course);
        }

        public async Task<IEnumerable<LectureSchedule>> GetSubjectSchedulesAsync(int subjectId)
        {
            var courseSubjects = await _courseSubjectRepository.GetCourseSubjectsBySubjectAsync(subjectId);
            var schedules = new List<LectureSchedule>();
            foreach (var courseSubject in courseSubjects)
            {
                var subjectSchedules = await _lectureScheduleRepository.GetSchedulesByCourseSubjectAsync(courseSubject.Id);
                schedules.AddRange(subjectSchedules);
            }
            return schedules;
        }
    }
}