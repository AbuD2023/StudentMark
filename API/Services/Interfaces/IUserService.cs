using API.Entities;

namespace API.Services.Interfaces
{
    public interface IUserService : IGenericService<User>
    {
        Task<User> GetUserWithRoleAsync(string username);
        Task<bool> IsUsernameUniqueAsync(string username);
        Task<IEnumerable<User>> GetUsersByRoleAsync(int roleId);
        Task<Student> GetStudentOfUserId(int UserId);
        Task<IEnumerable<User>> GetActiveUsersAsync();
        Task<IEnumerable<User>> GetAllUsersAsync();
        Task<bool> UpdateUserStatusAsync(int userId);
        Task<bool> UpdateLastLoginAsync(int userId);
        Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword);
        Task<bool> ResetPasswordAsync(int userId, string newPassword);
        Task<User> GetByUsernameAsync(string username);
        Task<bool> IsEmailUniqueAsync(string email);
        Task<bool> ValidateTokenAsync(string token);
        Task<IEnumerable<User>> GetDoctorUsersAsync();
        Task<IEnumerable<User>> GetStudentsUsersAsync();
        Task<IEnumerable<User>> GetUnassignedDoctors();
        Task<IEnumerable<User>> GetUnassignedStudents();
    }
}