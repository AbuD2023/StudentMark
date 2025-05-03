using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;

namespace API.Services
{
    public class RoleService : GenericService<Role>, IRoleService
    {
        private readonly IRoleRepository _roleRepository;
        private readonly IPermissionRepository _permissionRepository;

        public RoleService(IRoleRepository roleRepository, IPermissionRepository permissionRepository, IUnitOfWork unitOfWork)
            : base(roleRepository, unitOfWork)
        {
            _roleRepository = roleRepository;
            _permissionRepository = permissionRepository;
        }

        public async Task<Role?> GetRoleWithPermissionsAsync(int roleId)
        {
            return await _roleRepository.GetRoleWithPermissionsAsync(roleId);
        }

        public async Task<IEnumerable<Role>> GetActiveRolesAsync()
        {
            return await _roleRepository.GetActiveRolesAsync();
        }

        public async Task<bool> IsRoleNameUniqueAsync(string roleName)
        {
            return await _roleRepository.IsRoleNameUniqueAsync(roleName);
        }

        public async Task<bool> AssignPermissionToRoleAsync(int roleId, int permissionId)
        {
            var role = await _roleRepository.GetRoleWithPermissionsAsync(roleId);
            var permission = await _permissionRepository.GetByIdAsync(permissionId);

            if (role == null || permission == null)
                return false;

            var rolePermission = new RolePermission
            {
                RoleId = roleId,
                PermissionId = permissionId
            };

            role.RolePermissions.Add(rolePermission);
            _roleRepository.Update(role);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> RemovePermissionFromRoleAsync(int roleId, int permissionId)
        {
            var role = await _roleRepository.GetRoleWithPermissionsAsync(roleId);
            if (role == null)
                return false;

            var rolePermission = role.RolePermissions.FirstOrDefault(rp => rp.PermissionId == permissionId);
            if (rolePermission == null)
                return false;

            role.RolePermissions.Remove(rolePermission);
            _roleRepository.Update(role);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }
    }
}