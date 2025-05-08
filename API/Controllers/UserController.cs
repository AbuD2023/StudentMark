using API.DTOs;
using API.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using API.DTOs.Auth;
using API.Entities;
using API.Services;

namespace API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class UserController : ControllerBase
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        //private readonly IExcelImportService _excelImportService;

        public UserController(IUserService userService, /*IExcelImportService excelImportService,*/ IAuthService authService)
        {
            _userService = userService;
            //_excelImportService = excelImportService;
            _authService = authService;
        }

        [HttpPost("register")]
        [Authorize(Roles = "Admin,Coordinator")]
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
                    FullName = model.FullName,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.Password, BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = model.RoleId,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow
                };

                await _userService.AddAsync(user);

                return Ok(new { message = "User registered successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while registering the user", error = ex.Message });
            }
        }
        // public async Task<IActionResult> Register([FromBody] RegisterDto registerDto)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _authService.RegisterAsync(registerDto);
        //     if (!result.Succeeded)
        //     {
        //         return BadRequest(result.Errors);
        //     }
        //     return Ok(new { message = "User registered successfully" });
        // }

        //[HttpPost("import")]
        //[Authorize(Roles = "AcademicCoordinator")]
        //public async Task<IActionResult> ImportExcel([FromForm] ExcelImportDto importDto)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    if (importDto.File == null || importDto.File.Length == 0)
        //    {
        //        return BadRequest(new { message = "Please upload a file" });
        //    }

        //    if (!importDto.File.FileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
        //    {
        //        return BadRequest(new { message = "Only Excel files (.xlsx) are allowed" });
        //    }

        //    var result = await _excelImportService.ImportExcelAsync(importDto);

        //    return Ok(new
        //    {
        //        message = "Import completed",
        //        totalRecords = result.TotalRecords,
        //        successfullyImported = result.SuccessfullyImported,
        //        failedRecords = result.FailedRecords,
        //        errors = result.Errors,
        //        warnings = result.Warnings
        //    });
        //}

        [HttpGet]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _userService.GetAllUsersAsync();
            return Ok(users);
        }
        
        [HttpGet("{userId}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GetByIdAsync(int userId)
        {
            var users = await _userService.GetByIdAsync(userId);
            return Ok(users);
        }
        [HttpGet("doctorUser")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GetDoctorUsersAsync()
        {
            var users = await _userService.GetDoctorUsersAsync();
            return Ok(users);
        }
        
        [HttpGet("studentUser")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GetStudentsUsersAsync()
        {
            var users = await _userService.GetStudentsUsersAsync();
            return Ok(users);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public Task<IActionResult> UpdateAsync(int id, [FromBody] User user)
        {
            var users =  _userService.UpdateAsync(user);
            return Task.FromResult<IActionResult>(Ok(users));
        }
        
        [HttpPut("{id}/toggle-status")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> UpdateUserStatusAsync(int id)
        {
            //return Task.FromResult<IActionResult>(Ok(users));

            var user = await _userService.GetByIdAsync(id);
            if (user == null)
            {
                return NotFound(new { message = "User not found" });
            }

            //user.IsActive = !user.IsActive;
            //await _userService.UpdateUserStatusAsync(user.Id, !user.IsActive);
            //var users =  _userService.UpdateAsync(user);
            await  _userService.UpdateUserStatusAsync(id);
            return NoContent();
        }
        
        [HttpGet("active")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> GetActiveUsersAsync()
        {
            var users = await _userService.GetActiveUsersAsync();
            return Ok(users);
        }
        
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Coordinator")]
        public async Task<IActionResult> DeleteUserAsync(int id)
        {
            await _userService.DeleteAsync(id);
            return NoContent();
        }

        [HttpGet("unassigned-doctors")]
        public async Task<ActionResult<IEnumerable<User>>> GetUnassignedDoctors()
        {
            try
            {
                var unassignedDoctors = await _userService.GetUnassignedDoctors();
                return Ok(unassignedDoctors);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
        
        [HttpGet("unassigned-students")]
        public async Task<ActionResult<IEnumerable<User>>> GetUnassignedStudents()
        {
            try
            {
                var unassignedStudents= await _userService.GetUnassignedStudents();
                return Ok(unassignedStudents);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}