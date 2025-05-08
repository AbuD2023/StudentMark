using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class CourseService : GenericService<Course>, ICourseService
    {
        private readonly ICourseRepository _courseRepository;
        private readonly ICourseSubjectRepository _courseSubjectRepository;
        private readonly ISubjectRepository _subjectRepository;

        public CourseService(
            ICourseRepository courseRepository,
            ICourseSubjectRepository courseSubjectRepository,
            ISubjectRepository subjectRepository,
            IUnitOfWork unitOfWork)
            : base(courseRepository, unitOfWork)
        {
            _courseRepository = courseRepository;
            _courseSubjectRepository = courseSubjectRepository;
            _subjectRepository = subjectRepository;
        }

        public async Task<IEnumerable<Course>> GetCoursesByDepartmentAsync(int departmentId)
        {
            return await _courseRepository.GetCoursesByDepartmentAsync(departmentId);
        }
        public async Task<IEnumerable<Course>> GetAllCoursesAsync()
        {
            return await _courseRepository.GetAllCoursesAsync();
        }

        public async Task<Course?> GetCourseWithSubjectsAsync(int courseId)
        {
            return await _courseRepository.GetCourseWithSubjectsAsync(courseId);
        }

        public async Task<IEnumerable<Course>> GetActiveCoursesAsync()
        {
            return await _courseRepository.GetActiveCoursesAsync();
        }

        public async Task<bool> IsCourseNameUniqueInDepartmentAsync(string courseName, int departmentId)
        {
            return await _courseRepository.IsCourseNameUniqueInDepartmentAsync(courseName, departmentId);
        }

        public async Task<IEnumerable<Subject>> GetCourseSubjectsAsync(int courseId)
        {
            var courseSubjects = await _courseSubjectRepository.GetCourseSubjectsByCourseAsync(courseId);
            return courseSubjects.Select(cs => cs.Subject);
        }

        public async Task<bool> AddSubjectToCourseAsync(int courseId, int subjectId, int levelId)
        {
            if (!await _courseSubjectRepository.IsCourseSubjectUniqueAsync(courseId, subjectId, levelId))
                return false;

            var courseSubject = new CourseSubject
            {
                CourseId = courseId,
                SubjectId = subjectId,
                LevelId = levelId
            };

            await _courseSubjectRepository.AddAsync(courseSubject);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> RemoveSubjectFromCourseAsync(int courseId, int subjectId, int levelId)
        {
            var courseSubject = (await _courseSubjectRepository.GetCourseSubjectsByCourseAsync(courseId))
                .FirstOrDefault(cs => cs.SubjectId == subjectId && cs.LevelId == levelId);

            if (courseSubject == null)
                return false;

            _courseSubjectRepository.Remove(courseSubject);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }
    }
}