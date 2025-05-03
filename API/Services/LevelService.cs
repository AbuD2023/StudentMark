using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class LevelService : GenericService<Level>, ILevelService
    {
        private readonly ILevelRepository _levelRepository;
        private readonly ICourseRepository _courseRepository;
        private readonly IStudentRepository _studentRepository;

        public LevelService(
            ILevelRepository levelRepository,
            ICourseRepository courseRepository,
            IStudentRepository studentRepository,
            IUnitOfWork unitOfWork)
            : base(levelRepository, unitOfWork)
        {
            _levelRepository = levelRepository;
            _courseRepository = courseRepository;
            _studentRepository = studentRepository;
        }

        public async Task<IEnumerable<Level>> GetLevelsByDepartmentAsync(int departmentId)
        {
            return await _levelRepository.GetLevelsByDepartmentAsync(departmentId);
        }
        
        public async Task<IEnumerable<Level>> GetAllAsyncCopy()
        {
            return await _levelRepository.GetAllAsyncCopy();
        }

        public async Task<IEnumerable<Level>> GetActiveLevelsAsync()
        {
            return await _levelRepository.GetActiveLevelsAsync();
        }

        public async Task<bool> IsLevelNameUniqueInDepartmentAsync(string levelName, int departmentId)
        {
            return await _levelRepository.IsLevelNameUniqueInDepartmentAsync(levelName, departmentId);
        }

        public async Task<IEnumerable<Course>> GetLevelCoursesAsync(int levelId)
        {
            return await _courseRepository.GetCoursesByLevelAsync(levelId);
        }

        public async Task<IEnumerable<Student>> GetLevelStudentsAsync(int levelId)
        {
            return await _studentRepository.GetStudentsByLevelAsync(levelId);
        }

        public async Task<Level?> GetByNameAsync(string levelName)
        {
            return await _levelRepository.GetByNameAsync(levelName);
        }
    }
}