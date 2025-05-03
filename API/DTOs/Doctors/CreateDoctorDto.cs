// using System.ComponentModel.DataAnnotations;

// namespace API.DTOs.Doctors
// {
//     public class CreateDoctorDto
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
//         public List<CreateDoctorDepartmentLevelDto> Departments { get; set; }
//     }

//     public class CreateDoctorDepartmentLevelDto
//     {
//         [Required]
//         public int DepartmentId { get; set; }

//         [Required]
//         public int LevelId { get; set; }
//     }
// }