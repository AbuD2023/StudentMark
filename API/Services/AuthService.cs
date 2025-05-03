using API.DTOs.Auth;
using API.Entities;
using API.Repositories.Interfaces;
using API.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class AuthService : IAuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly IRoleRepository _roleRepository;
        private readonly JwtService _jwtService;

        public AuthService(
            IUserRepository userRepository,
            IRoleRepository roleRepository,
            JwtService jwtService)
        {
            _userRepository = userRepository;
            _roleRepository = roleRepository;
            _jwtService = jwtService;
        }

        public async Task<AuthResponseDto> LoginAsync(LoginDto loginDto)
        {
            var user = await _userRepository.GetUserWithRoleAsync(loginDto.Username);
            if (user == null)
            {
                throw new Exception("Invalid username or password");
            }

            if (!BCrypt.Net.BCrypt.Verify(loginDto.Password, user.Password))
            {
                throw new Exception("Invalid username or password");
            }

            if (!user.IsActive)
            {
                throw new Exception("Account is deactivated");
            }

            var token = _jwtService.GenerateToken(user);

            return new AuthResponseDto
            {
                Token = token,
                User = new UserDto
                {
                    Id = user.Id,
                    Username = user.Username,
                    Email = user.Email,
                    FullName = user.FullName,
                    Role = new RoleDto
                    {
                        Id = user.Role.Id,
                        Name = user.Role.Name,
                        Permissions = user.Role.RolePermissions
                            .Select(rp => new PermissionDto
                            {
                                Id = rp.Permission.Id,
                                Name = rp.Permission.Name
                            })
                            .ToList()
                    }
                }
            };
        }

        public async Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto)
        {
            if (await _userRepository.IsUsernameUniqueAsync(registerDto.Username))
            {
                throw new Exception("Username already exists");
            }

            if (await _userRepository.IsUsernameUniqueAsync(registerDto.Email))
            {
                throw new Exception("Email already exists");
            }

            var role = await _roleRepository.GetByIdAsync(registerDto.RoleId);
            if (role == null)
            {
                throw new Exception("Invalid role");
            }

            var user = new User
            {
                Id = 5,
                FullName = registerDto.FullName,
                Email = registerDto.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(registerDto.Password, BCrypt.Net.BCrypt.GenerateSalt(12)),
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                RoleId = registerDto.RoleId,
                Username = registerDto.Username,
                Password = BCrypt.Net.BCrypt.HashPassword(registerDto.Password, BCrypt.Net.BCrypt.GenerateSalt(12)),
                LastLoginAt = DateTime.UtcNow,
                RefreshToken = "",
                RefreshTokenExpiryTime = DateTime.UtcNow,
            };

            await _userRepository.AddAsync(user);

            var token = _jwtService.GenerateToken(user);

            return new AuthResponseDto
            {
                Token = token,
                User = new UserDto
                {
                    Id = user.Id,
                    Username = user.Username,
                    Email = user.Email,
                    FullName = user.FullName,
                    Role = new RoleDto
                    {
                        Id = role.Id,
                        Name = role.Name,
                        Permissions = role.RolePermissions
                            .Select(rp => new PermissionDto
                            {
                                Id = rp.Permission.Id,
                                Name = rp.Permission.Name
                            })
                            .ToList()
                    }
                }
            };
        }

        public async Task<bool> ValidateTokenAsync(string token)
        {
            return _jwtService.ValidateToken(token);
        }
    }
}