using System.ComponentModel.DataAnnotations;

namespace API.DTOs.Auth
{
    public class LoginDto
    {
        [Required]
        [StringLength(50)]
        public string Username { get; set; }

        [Required]
        [MinLength(6)]
        public string Password { get; set; }
    }
}