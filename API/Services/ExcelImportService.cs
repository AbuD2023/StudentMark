// using API.DTOs;
// using API.Entities;
// using API.Services.Interfaces;
// using OfficeOpenXml;
// using Microsoft.AspNetCore.Identity;

// namespace API.Services
// {
//     public class ExcelImportService : IExcelImportService
//     {
//         private readonly IStudentService _studentService;
//         private readonly IDoctorDepartmentsLevelsService _doctorService;
//         private readonly IDepartmentService _departmentService;
//         private readonly ILevelService _levelService;
//         private readonly UserManager<User> _userManager;
//         private readonly ILogger<ExcelImportService> _logger;

//         public ExcelImportService(
//             IStudentService studentService,
//             IDoctorDepartmentsLevelsService doctorService,
//             IDepartmentService departmentService,
//             ILevelService levelService,
//             UserManager<User> userManager,
//             ILogger<ExcelImportService> logger)
//         {
//             _studentService = studentService;
//             _doctorService = doctorService;
//             _departmentService = departmentService;
//             _levelService = levelService;
//             _userManager = userManager;
//             _logger = logger;
//         }

//         public async Task<ExcelImportResultDto> ImportExcelAsync(ExcelImportDto importDto)
//         {
//             var result = new ExcelImportResultDto
//             {
//                 Errors = new List<ImportErrorDto>(),
//                 Warnings = new List<ImportWarningDto>()
//             };

//             using var stream = new MemoryStream();
//             await importDto.File.CopyToAsync(stream);
//             using var package = new ExcelPackage(stream);
//             var worksheet = package.Workbook.Worksheets[0];
//             var rowCount = worksheet.Dimension.Rows;

//             result.TotalRecords = rowCount - 1; // Subtract header row

//             for (int row = 2; row <= rowCount; row++)
//             {
//                 try
//                 {
//                     if (importDto.ImportType == "Students")
//                     {
//                         await ProcessStudentRowAsync(worksheet, row, result);
//                     }
//                     else if (importDto.ImportType == "Doctors")
//                     {
//                         await ProcessDoctorRowAsync(worksheet, row, result);
//                     }
//                 }
//                 catch (Exception ex)
//                 {
//                     result.Errors.Add(new ImportErrorDto
//                     {
//                         RowNumber = row,
//                         ErrorMessage = ex.Message,
//                         Data = GetRowData(worksheet, row)
//                     });
//                     result.FailedRecords++;
//                 }
//             }

//             result.SuccessfullyImported = result.TotalRecords - result.FailedRecords;
//             return result;
//         }

//         private async Task ProcessStudentRowAsync(ExcelWorksheet worksheet, int row, ExcelImportResultDto result)
//         {
//             var fullName = worksheet.Cells[row, 1].Text.Trim();
//             var email = worksheet.Cells[row, 2].Text.Trim();
//             var departmentName = worksheet.Cells[row, 3].Text.Trim();
//             var levelName = worksheet.Cells[row, 4].Text.Trim();
//             var studentId = worksheet.Cells[row, 5].Text.Trim();

//             // Validate required fields
//             if (string.IsNullOrEmpty(fullName))
//             {
//                 throw new Exception("Full name is required");
//             }

//             // Generate email if not provided
//             if (string.IsNullOrEmpty(email))
//             {
//                 email = GenerateEmail(fullName, studentId);
//                 result.Warnings.Add(new ImportWarningDto
//                 {
//                     RowNumber = row,
//                     WarningMessage = "Email was not provided",
//                     Data = GetRowData(worksheet, row),
//                     ActionTaken = $"Generated email: {email}"
//                 });
//             }

//             // Validate email format
//             if (!IsValidEmail(email))
//             {
//                 throw new Exception("Invalid email format");
//             }

//             // Get department
//             var department = await _departmentService.GetByNameAsync(departmentName);
//             if (department == null)
//             {
//                 throw new Exception($"Department '{departmentName}' not found");
//             }

//             // Get level
//             var level = await _levelService.GetByNameAsync(levelName);
//             if (level == null)
//             {
//                 throw new Exception($"Level '{levelName}' not found");
//             }
//             var password = GeneratePassword(fullName, studentId);
//             // Create user
//             var user = new User
//             {
//                 Username = email,
//                 Email = email,
//                 FullName = fullName,
//                 PasswordHash = BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12)),
//                 Password = BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12)),
//                 RoleId = 3,
//                 IsActive = true,
//                 CreatedAt = DateTime.UtcNow
//             };


//             var createUserResult = await _userManager.CreateAsync(user, password);

//             if (!createUserResult.Succeeded)
//             {
//                 throw new Exception($"Failed to create user: {string.Join(", ", createUserResult.Errors.Select(e => e.Description))}");
//             }

//             // Add to Student role
//             await _userManager.AddToRoleAsync(user, "Student");

//             // Create student
//             var student = new Student
//             {
//                 UserId = user.Id,
//                 DepartmentId = department.Id,
//                 LevelId = level.Id,
//                 EnrollmentYear = DateTime.Now.Year,
//                 IsActive = true
//             };

//             await _studentService.AddAsync(student);

//             // Log success
//             _logger.LogInformation($"Successfully imported student: {fullName} ({email})");
//         }

//         private async Task ProcessDoctorRowAsync(ExcelWorksheet worksheet, int row, ExcelImportResultDto result)
//         {
//             var fullName = worksheet.Cells[row, 1].Text.Trim();
//             var email = worksheet.Cells[row, 2].Text.Trim();
//             var departmentNames = worksheet.Cells[row, 3].Text.Trim().Split(',').Select(d => d.Trim());
//             var title = worksheet.Cells[row, 4].Text.Trim();

//             // Validate required fields
//             if (string.IsNullOrEmpty(fullName))
//             {
//                 throw new Exception("Full name is required");
//             }

//             // Generate email if not provided
//             if (string.IsNullOrEmpty(email))
//             {
//                 email = GenerateEmail(fullName, null);
//                 result.Warnings.Add(new ImportWarningDto
//                 {
//                     RowNumber = row,
//                     WarningMessage = "Email was not provided",
//                     Data = GetRowData(worksheet, row),
//                     ActionTaken = $"Generated email: {email}"
//                 });
//             }

//             // Validate email format
//             if (!IsValidEmail(email))
//             {
//                 throw new Exception("Invalid email format");
//             }
//             var password = GeneratePassword(fullName, null);
//             // Create user
//             var user = new User
//             {
//                 Username = email,
//                 Email = email,
//                 FullName = fullName,
//                 PasswordHash = BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12)),
//                 Password = BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12)),
//                 RoleId = 2,
//                 IsActive = true,
//                 CreatedAt = DateTime.UtcNow
//             };


//             var createUserResult = await _userManager.CreateAsync(user, password);

//             if (!createUserResult.Succeeded)
//             {
//                 throw new Exception($"Failed to create user: {string.Join(", ", createUserResult.Errors.Select(e => e.Description))}");
//             }

//             // Add to Doctor role
//             await _userManager.AddToRoleAsync(user, "Doctor");

//             // Create doctor assignment
//             foreach (var departmentName in departmentNames)
//             {
//                 var department = await _departmentService.GetByNameAsync(departmentName);
//                 if (department != null)
//                 {
//                     var assignment = new DoctorDepartmentsLevels
//                     {
//                         DoctorId = user.Id,
//                         DepartmentId = department.Id,
//                         LevelId = 0,
//                         IsActive = true
//                     };

//                     await _doctorService.AddAsync(assignment);
//                 }
//                 else
//                 {
//                     result.Warnings.Add(new ImportWarningDto
//                     {
//                         RowNumber = row,
//                         WarningMessage = $"Department '{departmentName}' not found",
//                         Data = GetRowData(worksheet, row),
//                         ActionTaken = "Skipped department assignment"
//                     });
//                 }
//             }

//             // Log success
//             _logger.LogInformation($"Successfully imported doctor: {fullName} ({email})");
//         }

//         private string GenerateEmail(string fullName, string? studentId)
//         {
//             var baseEmail = $"{fullName.Replace(" ", ".").ToLower()}";
//             if (!string.IsNullOrEmpty(studentId))
//             {
//                 baseEmail += $".{studentId}";
//             }
//             return $"{baseEmail}@gmail.com";
//             // return $"{baseEmail}@university.edu";
//         }

//         private string GeneratePassword(string fullName, string? studentId)
//         {
//             var basePassword = fullName.Replace(" ", "").ToLower();
//             if (!string.IsNullOrEmpty(studentId))
//             {
//                 basePassword += studentId;
//             }
//             return $"{basePassword}@123";
//         }

//         private bool IsValidEmail(string email)
//         {
//             try
//             {
//                 var addr = new System.Net.Mail.MailAddress(email);
//                 return addr.Address == email;
//             }
//             catch
//             {
//                 return false;
//             }
//         }

//         private string GetRowData(ExcelWorksheet worksheet, int row)
//         {
//             var data = new List<string>();
//             for (int col = 1; col <= worksheet.Dimension.Columns; col++)
//             {
//                 data.Add(worksheet.Cells[row, col].Text);
//             }
//             return string.Join(", ", data);
//         }
//     }
// }