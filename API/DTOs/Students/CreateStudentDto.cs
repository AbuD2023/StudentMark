// using System.ComponentModel.DataAnnotations;

// namespace API.DTOs.Students
// {
//     public class CreateStudentDto
//     {
//         [Required]
//         [EmailAddress]
//         public string Email { get; set; }

//         [Required]
//         [MinLength(6)]
//         public string Password { get; set; }

//         [Required]
//         [StringLength(100)]
//         public string FullName { get; set; }

//         [Required]
//         public int DepartmentId { get; set; }

//         [Required]
//         public int LevelId { get; set; }

//         [Required]
//         public int EnrollmentYear { get; set; }
//     }
// }