using API.Data;
using API.Entities;
using API.Repositories;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace API.Services
{
    public class UserService : GenericService<User>, IUserService
    {
        private readonly IUserRepository _userRepository;
        private readonly IRoleRepository _roleRepository;
        private readonly ApplicationDbContext _context;
        private readonly IDoctorDepartmentsLevelsRepository _doctorDepartmentsLevelsRepository;
        private readonly IStudentRepository _studentRepository;

        public UserService(IUserRepository userRepository, IRoleRepository roleRepository, IUnitOfWork unitOfWork, ApplicationDbContext context, IDoctorDepartmentsLevelsRepository doctorDepartmentsLevelsRepository, IStudentRepository studentRepository)
            : base(userRepository, unitOfWork)
        {
            _userRepository = userRepository;
            _roleRepository = roleRepository;
            _context = context;
            _doctorDepartmentsLevelsRepository = doctorDepartmentsLevelsRepository;
            _studentRepository = studentRepository;

        }

        public async Task<User> GetUserWithRoleAsync(string username)
        {
            var user = await _userRepository.GetUserWithRoleAsync(username);
            if (user == null)
                throw new Exception("User not found");
            return user;
        }

        public async Task<bool> IsUsernameUniqueAsync(string username)
        {
            return await _userRepository.IsUsernameUniqueAsync(username);
        }

        public async Task<IEnumerable<User>> GetUsersByRoleAsync(int roleId)
        {
            return await _userRepository.GetUsersByRoleAsync(roleId);
        }

        public async Task<IEnumerable<User>> GetActiveUsersAsync()
        {
            return await _userRepository.GetActiveUsersAsync();
        }
        
        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            return await _userRepository.GetAllUsersAsync();
        }

        public async Task<IEnumerable<User>> GetDoctorUsersAsync()
        {
            var rool = await _roleRepository.GetAllAsync();
            //int doctorRoolId = rool.Where(ro => ro.Name == "Doctor").Select(ro=> ro.Id).First();
            var doctorRole = rool.First(r => r.Name == "Doctor");
            return await _userRepository.GetUsersByRoleIdAsync(doctorRole.Id);
        }
        
        public async Task<IEnumerable<User>> GetStudentsUsersAsync()
        {
            var rool = await _roleRepository.GetAllAsync();
            //int doctorRoolId = rool.Where(ro => ro.Name == "Doctor").Select(ro=> ro.Id).First();
            var doctorRole = rool.First(r => r.Name == "Student");
            return (await _userRepository.GetUsersByRoleIdAsync(doctorRole.Id));
        }

        public async Task<bool> UpdateUserStatusAsync(int userId)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            user.IsActive = !user.IsActive;
            _userRepository.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateLastLoginAsync(int userId)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            user.LastLoginAt = DateTime.UtcNow;
            _userRepository.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            if (!BCrypt.Net.BCrypt.Verify(currentPassword, user.Password))
                throw new Exception("Current password is incorrect");

            user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);
            _userRepository.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ResetPasswordAsync(int userId, string newPassword)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);
            _userRepository.Update(user);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<User> GetByUsernameAsync(string username)
        {
            return await _context.Users
                .FirstOrDefaultAsync(u => u.Username == username);
        }

        public async Task<bool> IsEmailUniqueAsync(string email)
        {
            return await _context.Users
                .AnyAsync(u => u.Email == email);
        }

        public async Task<bool> ValidateTokenAsync(string token)
        {
            // Implement token validation logic here
            // This is a placeholder implementation
            return !string.IsNullOrEmpty(token);
        }

        public async Task<IEnumerable<User>> GetUnassignedDoctors()
        {
            var allDoctors = await _userRepository.GetAllAsync();
            var assignedDoctors = await _doctorDepartmentsLevelsRepository.GetAllAsync();

            // Get all doctors with role ID 2 (Doctor role)
            var rool = await _roleRepository.GetAllAsync();
            var doctorRole = rool.First(r => r.Name == "Doctor");
            var doctors = allDoctors.Where(u => u.RoleId == doctorRole.Id);

            // Get IDs of assigned doctors
            var assignedDoctorIds = assignedDoctors.Select(d => d.DoctorId).Distinct();

            // Return doctors that are not assigned to any department/level
            return doctors.Where(d => !assignedDoctorIds.Contains(d.Id))/*.ToList()*/;
        }
        
        public async Task<IEnumerable<User>> GetUnassignedStudents()
        {
            var allDoctors = await _userRepository.GetAllAsync();
            var assignedStudents= await _studentRepository.GetAllAsync();

            // Get all doctors with role ID 2 (Doctor role)
            var rool = await _roleRepository.GetAllAsync();
            var studentRole = rool.First(r => r.Name == "Student");
            var students = allDoctors.Where(u => u.RoleId == studentRole.Id);

            // Get IDs of assigned doctors
            var assignedStudentIds= assignedStudents.Select(d => d.UserId).Distinct();

            // Return doctors that are not assigned to any department/level
            return students.Where(d => !assignedStudentIds.Contains(d.Id))/*.ToList()*/;
        }
    }
}