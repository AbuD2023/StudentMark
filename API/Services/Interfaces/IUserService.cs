using API.Entities;

namespace API.Services.Interfaces
{
    public interface IUserService : IGenericService<User>
    {
        Task<User> GetUserWithRoleAsync(string username);
        Task<bool> IsUsernameUniqueAsync(string username);
        Task<IEnumerable<User>> GetUsersByRoleAsync(int roleId);
        Task<IEnumerable<User>> GetActiveUsersAsync();
        Task<bool> UpdateUserStatusAsync(int userId, bool isActive);
        Task<bool> UpdateLastLoginAsync(int userId);
        Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword);
        Task<bool> ResetPasswordAsync(int userId, string newPassword);
        Task<User> GetByUsernameAsync(string username);
        Task<bool> IsEmailUniqueAsync(string email);
        Task<bool> ValidateTokenAsync(string token);
    }
}