using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class DoctorDepartmentsLevelsService : GenericService<DoctorDepartmentsLevels>, IDoctorDepartmentsLevelsService
    {
        private readonly IDoctorDepartmentsLevelsRepository _doctorDepartmentsLevelsRepository;

        public DoctorDepartmentsLevelsService(
            IDoctorDepartmentsLevelsRepository doctorDepartmentsLevelsRepository,
            IUnitOfWork unitOfWork)
            : base(doctorDepartmentsLevelsRepository, unitOfWork)
        {
            _doctorDepartmentsLevelsRepository = doctorDepartmentsLevelsRepository;
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByDoctorAsync(int doctorId)
        {
            return await _doctorDepartmentsLevelsRepository.GetByDoctorAsync(doctorId);
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByDepartmentAsync(int departmentId)
        {
            return await _doctorDepartmentsLevelsRepository.GetByDepartmentAsync(departmentId);
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetByLevelAsync(int levelId)
        {
            return await _doctorDepartmentsLevelsRepository.GetByLevelAsync(levelId);
        }

        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetActiveAssignmentsAsync()
        {
            return await _doctorDepartmentsLevelsRepository.GetActiveAssignmentsAsync();
        }
        
        public async Task<IEnumerable<DoctorDepartmentsLevels>> GetAllDoctorAsync()
        {
            return await _doctorDepartmentsLevelsRepository.GetAllDoctorAsync();
        }

        public async Task<bool> IsAssignmentUniqueAsync(int doctorId, int departmentId, int levelId)
        {
            return await _doctorDepartmentsLevelsRepository.IsAssignmentUniqueAsync(doctorId, departmentId, levelId);
        }

        public async Task<bool> AssignDoctorToDepartmentLevelAsync(int doctorId, int departmentId, int levelId)
        {
            if (!await IsAssignmentUniqueAsync(doctorId, departmentId, levelId))
                return false;

            var assignment = new DoctorDepartmentsLevels
            {
                DoctorId = doctorId,
                DepartmentId = departmentId,
                LevelId = levelId,
                IsActive = true
            };

            await _doctorDepartmentsLevelsRepository.AddAsync(assignment);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> RemoveDoctorFromDepartmentLevelAsync(int doctorId, int departmentId, int levelId)
        {
            var assignments = await _doctorDepartmentsLevelsRepository.GetByDoctorAsync(doctorId);
            var assignment = assignments.FirstOrDefault(a =>
                a.DepartmentId == departmentId &&
                a.LevelId == levelId &&
                a.IsActive);

            if (assignment == null)
                return false;

            assignment.IsActive = false;
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> AddToDepartmentAsync(int doctorId, int departmentId)
        {
            var assignment = new DoctorDepartmentsLevels
            {
                DoctorId = doctorId,
                DepartmentId = departmentId,
                LevelId = 0, // Default level
                IsActive = true
            };

            await _doctorDepartmentsLevelsRepository.AddAsync(assignment);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }
    }
}