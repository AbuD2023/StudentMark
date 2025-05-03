 using System.ComponentModel.DataAnnotations;

namespace API.Entities
{
    public abstract class BaseEntity
    {
        [Key]
        public int Id { get; set; }
    }
}