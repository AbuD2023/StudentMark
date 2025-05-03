// using System.ComponentModel.DataAnnotations;

// namespace API.DTOs
// {
//     public class RegisterDto
//     {
//         [Required]
//         [StringLength(50)]
//         public string Username { get; set; }

//         [Required]
//         [EmailAddress]
//         [StringLength(100)]
//         public string Email { get; set; }

//         [Required]
//         [StringLength(100, MinimumLength = 6)]
//         public string Password { get; set; }

//         [Required]
//         [StringLength(100)]
//         public string FullName { get; set; }

//         [Required]
//         public int RoleId { get; set; }
//     }
// }