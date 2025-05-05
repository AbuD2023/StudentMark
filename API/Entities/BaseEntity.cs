using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace API.Entities
{
    //[PrimaryKey(nameof(Id))]
    public abstract class BaseEntity
    {
        [Required]
        [Key]
        public int Id { get; set; }
    }
}