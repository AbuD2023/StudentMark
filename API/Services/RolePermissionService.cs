using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class RolePermissionService : GenericService<RolePermission>, IRolePermissionService
    {
        private readonly IRolePermissionRepository _rolePermissionRepository;
        private readonly IRoleRepository _roleRepository;
        private readonly IPermissionRepository _permissionRepository;

        public RolePermissionService(
            IRolePermissionRepository rolePermissionRepository,
            IRoleRepository roleRepository,
            IPermissionRepository permissionRepository) : base(rolePermissionRepository)
        {
            _rolePermissionRepository = rolePermissionRepository;
            _roleRepository = roleRepository;
            _permissionRepository = permissionRepository;
        }

        public async Task<IEnumerable<RolePermission>> GetPermissionsByRoleAsync(int roleId)
        {
            return await _rolePermissionRepository.GetPermissionsByRoleAsync(roleId);
        }

        public async Task<IEnumerable<RolePermission>> GetRolesByPermissionAsync(int permissionId)
        {
            return await _rolePermissionRepository.GetRolesByPermissionAsync(permissionId);
        }

        public async Task<bool> IsRolePermissionUniqueAsync(int roleId, int permissionId)
        {
            return await _rolePermissionRepository.IsRolePermissionUniqueAsync(roleId, permissionId);
        }

        public async Task AssignPermissionToRoleAsync(int roleId, int permissionId)
        {
            var role = await _roleRepository.GetByIdAsync(roleId);
            if (role == null)
            {
                throw new InvalidOperationException("Role not found");
            }

            var permission = await _permissionRepository.GetByIdAsync(permissionId);
            if (permission == null)
            {
                throw new InvalidOperationException("Permission not found");
            }

            if (!await IsRolePermissionUniqueAsync(roleId, permissionId))
            {
                throw new InvalidOperationException("Permission is already assigned to this role");
            }

            var rolePermission = new RolePermission
            {
                RoleId = roleId,
                PermissionId = permissionId
            };

            await _rolePermissionRepository.AddAsync(rolePermission);
        }

        public async Task RemovePermissionFromRoleAsync(int roleId, int permissionId)
        {
            var rolePermission = await _rolePermissionRepository.GetAllAsync();
            var existingRolePermission = rolePermission.FirstOrDefault(rp =>
                rp.RoleId == roleId && rp.PermissionId == permissionId);

            if (existingRolePermission == null)
            {
                throw new InvalidOperationException("Permission is not assigned to this role");
            }

            _rolePermissionRepository.Remove(existingRolePermission);
        }

        public async Task<bool> HasPermissionAsync(int roleId, string permissionName)
        {
            var permissions = await GetPermissionsByRoleAsync(roleId);
            return permissions.Any(p => p.Permission.Name == permissionName);
        }
    }
}