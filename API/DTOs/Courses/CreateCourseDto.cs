// using System.ComponentModel.DataAnnotations;

// namespace API.DTOs.Courses
// {
//     public class CreateCourseDto
//     {
//         [Required]
//         [StringLength(100)]
//         public string CourseName { get; set; }

//         [StringLength(500)]
//         public string Description { get; set; }

//         [Required]
//         public int DepartmentId { get; set; }

//         [Required]
//         public List<CreateCourseSubjectDto> Subjects { get; set; }
//     }

//     public class CreateCourseSubjectDto
//     {
//         [Required]
//         public int SubjectId { get; set; }

//         [Required]
//         public int LevelId { get; set; }
//     }
// }