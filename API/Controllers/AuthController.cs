using API.DTOs.Auth;
using API.Entities;
using API.Services;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IConfiguration _configuration;
        private readonly IStudentService _studentService;
        private readonly IRoleService _roleService;
        private readonly IDoctorDepartmentsLevelsService _doctorDepartmentsLevelsService;

        public AuthController(IUserService userService, IConfiguration configuration, IDoctorDepartmentsLevelsService doctorDepartmentsLevelsService, IStudentService studentService, IRoleService roleService)
        {
            _userService = userService ?? throw new ArgumentNullException(nameof(userService));
            _configuration = configuration ?? throw new ArgumentNullException(nameof(configuration));
            _doctorDepartmentsLevelsService = doctorDepartmentsLevelsService ?? throw new ArgumentNullException(nameof(doctorDepartmentsLevelsService));
            _studentService = studentService;
            _roleService = roleService;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(new { message = "Invalid model state", errors = ModelState.Values.SelectMany(v => v.Errors) });
                }

                // Check if username already exists
                if (await _userService.IsUsernameUniqueAsync(model.Username))
                {
                    return BadRequest(new { message = "Username already exists" });
                }

                // Check if email already exists
                if (await _userService.IsEmailUniqueAsync(model.Email))
                {
                    return BadRequest(new { message = "Email already exists" });
                }

                var user = new User
                {
                    Username = model.Username,
                    Email = model.Email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.Password, BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password = BCrypt.Net.BCrypt.HashPassword(model.Password, BCrypt.Net.BCrypt.GenerateSalt(12)),
                    FullName = model.FullName,
                    RoleId = model.RoleId,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                };

                await _userService.AddAsync(user);

                //if(user.RoleId == 2)
                //{
                //    var doctorDepartmentsLevels = new DoctorDepartmentsLevels
                //    {
                //       DepartmentId = 0,
                //       DoctorId = user.Id,
                //       IsActive = true,
                //       LevelId = 0
                //    };

                //    await _doctorDepartmentsLevelsService.AddAsync(doctorDepartmentsLevels);
                //}

                return Ok(new { message = "User registered successfully", id = user.Id });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while registering the user", error = ex.Message });
            }
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(new { message = "Invalid model state", errors = ModelState.Values.SelectMany(v => v.Errors) });
                }

                var user = await _userService.GetByUsernameAsync(model.Username);
                if (user == null)
                {
                    return BadRequest(new { message = "Invalid username or password" });
                }

                if (!BCrypt.Net.BCrypt.Verify(model.Password, user.PasswordHash))
                {
                    return BadRequest(new { message = "Invalid username or password" });
                }

                if (!user.IsActive)
                {
                    return BadRequest(new { message = "Account is deactivated" });
                }

                var role = await _roleService.GetRoleWithPermissionsAsync(user.RoleId);
                var doctor = await _doctorDepartmentsLevelsService.GetByDoctorAsync(user.Id);
                var student = await _userService.GetStudentOfUserId(user.Id);

                if (role == null)
                {
                    return BadRequest(new { message = "لا يوجد لديك اي صلاحية لاستخدام التطبيق" });
                }

                var token = GenerateJwtToken(user);

                if (role.Name == "Admin")
                {
                    return Ok(new
                    {
                        token,
                        user = new
                        {
                            user.Id,
                            user.Username,
                            user.Email,
                            user.FullName,
                            user.RoleId,
                            user.IsActive,
                        },
                      roleName = user.Role.Name,

                    });
                }

                if (role.Name == "Doctor")
                {
                   
                    return Ok(new
                    {
                        token,
                        user = new
                        {
                            user.Id,
                            user.Username,
                            user.Email,
                            user.FullName,
                            user.RoleId,
                            user.IsActive,
                        },
                        doctor,
                        roleName = user.Role.Name,
                    });
                }

                if (role.Name == "Student")
                {
                    return Ok(new
                    {
                        token,
                        user = new
                        {
                            user.Id,
                            user.Username,
                            user.Email,
                            user.FullName,
                            user.RoleId,
                            user.IsActive,
                        },
                        student,
                        roleName = user.Role.Name,
                    });
                }

                return Ok(new
                {
                    token,
                    user = new
                    {
                        user.Id,
                        user.Username,
                        user.Email,
                        user.FullName,
                        user.RoleId,
                        user.IsActive,
                    },
                    roleName = user.Role.Name,
                });

            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while logging in", error = ex.Message });
            }
        }

        private string GenerateJwtToken(User user)
        {
            // Get role name based on role ID
            string roleName = user.RoleId switch
            {
                1 => "Admin",
                2 => "Doctor",
                3 => "Student",
                4 => "Coordinator",
                _ => "Unknown"
            };

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, roleName)
            };

            var key = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(
                System.Text.Encoding.UTF8.GetBytes(_configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key not found")));
            var creds = new Microsoft.IdentityModel.Tokens.SigningCredentials(key, Microsoft.IdentityModel.Tokens.SecurityAlgorithms.HmacSha256);

            var token = new System.IdentityModel.Tokens.Jwt.JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds);

            return new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpGet("validate-token")]
        [Authorize]
        public async Task<ActionResult<bool>> ValidateToken()
        {
            try
            {
                var token = Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
                var isValid = await _userService.ValidateTokenAsync(token);
                return Ok(isValid);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpGet("check-permission")]
        [Authorize]
        public async Task<IActionResult> CheckPermission()
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                var roleId = User.FindFirst(ClaimTypes.Role)?.Value;

                if (string.IsNullOrEmpty(userId) || string.IsNullOrEmpty(roleId))
                {
                    return Unauthorized(new { message = "Invalid token claims" });
                }

                var user = await _userService.GetByIdAsync(int.Parse(userId));
                if (user == null)
                {
                    return Unauthorized(new { message = "User not found" });
                }

                return Ok(new
                {
                    userId = user.Id,
                    roleId = user.RoleId,
                    hasPermission = user.RoleId == 1 || user.RoleId == 2 // Admin or Coordinator
                });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while checking permissions", error = ex.Message });
            }
        }
    }
}