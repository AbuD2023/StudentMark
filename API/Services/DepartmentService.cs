using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class DepartmentService : GenericService<Department>, IDepartmentService
    {
        private readonly IDepartmentRepository _departmentRepository;
        private readonly ICourseRepository _courseRepository;
        private readonly IStudentRepository _studentRepository;

        public DepartmentService(
            IDepartmentRepository departmentRepository,
            ICourseRepository courseRepository,
            IStudentRepository studentRepository,
            IUnitOfWork unitOfWork)
            : base(departmentRepository, unitOfWork)
        {
            _departmentRepository = departmentRepository;
            _courseRepository = courseRepository;
            _studentRepository = studentRepository;
        }

        public async Task<Department?> GetDepartmentWithLevelsAsync(int departmentId)
        {
            return await _departmentRepository.GetDepartmentWithLevelsAsync(departmentId);
        }

        public async Task<IEnumerable<Department>> GetActiveDepartmentsAsync()
        {
            return await _departmentRepository.GetActiveDepartmentsAsync();
        }

        public async Task<bool> IsDepartmentNameUniqueAsync(string departmentName)
        {
            return await _departmentRepository.IsDepartmentNameUniqueAsync(departmentName);
        }

        public async Task<IEnumerable<Course>> GetDepartmentCoursesAsync(int departmentId)
        {
            return await _courseRepository.GetCoursesByDepartmentAsync(departmentId);
        }

        public async Task<IEnumerable<Student>> GetDepartmentStudentsAsync(int departmentId)
        {
            return await _studentRepository.GetStudentsByDepartmentAsync(departmentId);
        }

        public async Task<Department?> GetByNameAsync(string departmentName)
        {
            return await _departmentRepository.GetByNameAsync(departmentName);
        }
    }
}