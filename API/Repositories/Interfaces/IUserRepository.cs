using API.Entities;

namespace API.Repositories.Interfaces
{
    public interface IUserRepository : IGenericRepository<User>
    {
        Task<User> GetUserWithRoleAsync(string username);
        Task<bool> IsUsernameUniqueAsync(string username);
        Task<IEnumerable<User>> GetUsersByRoleAsync(int roleId);
        Task<IEnumerable<User>> GetActiveUsersAsync();
    }
}