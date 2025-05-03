using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace API.Entities
{
    [Table("Permissions")]
    public class Permission : BaseEntity
    {
        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [StringLength(200)]
        public string Description { get; set; }

        [Required]
        [StringLength(50)]
        public string Module { get; set; }

        // Navigation Properties
        public ICollection<RolePermission> RolePermissions { get; set; }
    }
}