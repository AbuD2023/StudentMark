using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class PermissionService : GenericService<Permission>, IPermissionService
    {
        private readonly IPermissionRepository _permissionRepository;

        public PermissionService(IPermissionRepository permissionRepository, IUnitOfWork unitOfWork)
            : base(permissionRepository, unitOfWork)
        {
            _permissionRepository = permissionRepository;
        }

        public async Task<IEnumerable<Permission>> GetPermissionsByModuleAsync(string module)
        {
            return await _permissionRepository.GetPermissionsByModuleAsync(module);
        }

        public async Task<IEnumerable<Permission>> GetPermissionsByRoleAsync(int roleId)
        {
            return await _permissionRepository.GetPermissionsByRoleAsync(roleId);
        }

        public async Task<bool> IsPermissionNameUniqueAsync(string permissionName)
        {
            return await _permissionRepository.IsPermissionNameUniqueAsync(permissionName);
        }
    }
}