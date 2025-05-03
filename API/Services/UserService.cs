using API.Data;
using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class UserService : GenericService<User>, IUserService
    {
        private readonly IUserRepository _userRepository;
        private readonly ApplicationDbContext _context;

        public UserService(IUserRepository userRepository, IUnitOfWork unitOfWork, ApplicationDbContext context)
            : base(userRepository, unitOfWork)
        {
            _userRepository = userRepository;
            _context = context;
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

        public async Task<bool> UpdateUserStatusAsync(int userId, bool isActive)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            if (user == null)
                throw new Exception("User not found");

            user.IsActive = isActive;
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
    }
}