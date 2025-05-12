using API.Entities;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;

namespace API.Data
{
    public static class SeedData
    {
        public static async Task Initialize(IServiceProvider serviceProvider)
        {
            using var context = new ApplicationDbContext(
                serviceProvider.GetRequiredService<DbContextOptions<ApplicationDbContext>>());

            // Check if data already exists
            if (context.Users.Any())
            {
                Console.WriteLine("Database has been seeded");
                return;
            }

            // Create Roles
            var roles = new List<Role>
            {
                new Role { Name = "Admin", Description = "System Administrator" },
                new Role { Name = "Doctor", Description = "Teaching Staff" },
                new Role { Name = "Student", Description = "Student" }
            };
            await context.Roles.AddRangeAsync(roles);
            await context.SaveChangesAsync();

            // Create Permissions
            var permissions = new List<Permission>
            {
                new Permission { Name = "Manage Users", Module = "Users", Description = "Manage Users" },
                new Permission { Name = "View Users", Module = "Users", Description = "View Users" },
                new Permission { Name = "Manage Roles", Module = "Roles", Description = "Manage Roles" },
                new Permission { Name = "View Roles", Module = "Roles", Description = "View Roles" },
                new Permission { Name = "Manage Departments", Module = "Departments", Description = "Manage Departments" },
                new Permission { Name = "View Departments", Module = "Departments", Description = "View Departments" },
                new Permission { Name = "Manage Courses", Module = "Courses", Description = "Manage Courses" },
                new Permission { Name = "View Courses", Module = "Courses", Description = "View Courses" },
                new Permission { Name = "Manage Attendance", Module = "Attendance", Description = "Manage Attendance" },
                new Permission { Name = "View Attendance", Module = "Attendance", Description = "View Attendance" }
            };
            await context.Permissions.AddRangeAsync(permissions);
            await context.SaveChangesAsync();

            // Assign Permissions to Roles
            var rolePermissions = new List<RolePermission>();
            var adminRole = roles.First(r => r.Name == "Admin");
            var doctorRole = roles.First(r => r.Name == "Doctor");
            var studentRole = roles.First(r => r.Name == "Student");

            // Admin gets all permissions
            foreach (var permission in permissions)
            {
                rolePermissions.Add(new RolePermission
                {
                    RoleId = adminRole.Id,
                    PermissionId = permission.Id
                });
            }

            // Doctor gets specific permissions
            var doctorPermissions = permissions.Where(p =>
                p.Module == "Courses" ||
                p.Module == "Attendance" ||
                p.Name == "View Departments").ToList();
            foreach (var permission in doctorPermissions)
            {
                rolePermissions.Add(new RolePermission
                {
                    RoleId = doctorRole.Id,
                    PermissionId = permission.Id
                });
            }

            // Student gets view permissions
            var studentPermissions = permissions.Where(p =>
                p.Name.StartsWith("View")).ToList();
            foreach (var permission in studentPermissions)
            {
                rolePermissions.Add(new RolePermission
                {
                    RoleId = studentRole.Id,
                    PermissionId = permission.Id
                });
            }

            await context.RolePermissions.AddRangeAsync(rolePermissions);
            await context.SaveChangesAsync();

            // Create Departments
            var departments = new List<Department>
            {
                new Department { DepartmentName = "Computer Science", Description = "CS Department", IsActive = true },
                new Department { DepartmentName = "Information Technology", Description = "IT Department", IsActive = true },
                new Department { DepartmentName = "Software Engineering", Description = "SE Department", IsActive = true },
                new Department { DepartmentName = "تقنية معلومات", Description = "قسم الـ IT", IsActive = true },
            };
            await context.Departments.AddRangeAsync(departments);
            await context.SaveChangesAsync();

            

            // Create Users (Admin, Doctor, Student)
            var users = new List<User>
            {
                new User
                {
                    Username = "admin",
                    FullName = "Admin",
                    Email = "admin@example.com",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("Admin123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = adminRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow,
                    Address = "aaa",
                    Age = 50,
                    PhoneOne = "7788977",
                    PhoneTow = "88559999",
                    Sex = true,
                },
                new User
                {
                    Username = "hifa",
                    FullName = "هيفا الحمادي",
                    Email = "hifa@example.com",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Hifa123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("Hifa123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = adminRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow,
                    Address = "aaa",
                    Age = 50,
                    PhoneOne = "7788977",
                    PhoneTow = "88559999",
                    Sex = true,
                },
               
                new User
                {
                    Username = "ebrahim",
                    FullName = "إبراهيم البلطة",
                    Email = "ebrahim@example.com",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Ebrahim123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("Ebrahim123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = doctorRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow,
                    Address = "aaa",
                    Age = 50,
                    PhoneOne = "7788977",
                    PhoneTow = "88559999",
                    Sex = true,
                },
                new User
                {
                    Username = "mohdAljodah",
                    FullName = "محمد الجودة",
                    Email = "mohdAljodah@example.com",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("MohdAljodah123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("MohdAljodah123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = doctorRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow

                },
                new User
                {
                    Username = "mohmdAlsnbany",
                    Email = "mohmdAlsnbany@example.com",
                    FullName = "محمد السنباني",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("MohmdAlsnbany123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("MohmdAlsnbany123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = studentRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow,
                    Address = "aaa",
                    Age = 50,
                    PhoneOne = "7788977",
                    PhoneTow = "88559999",
                    Sex = true,
                },
                new User
                {
                    Username = "احمد",
                    Email = "ahmed@example.com",
                    FullName = "احمد علي",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("ahmed123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    Password= BCrypt.Net.BCrypt.HashPassword("ahmed123!", BCrypt.Net.BCrypt.GenerateSalt(12)),
                    RoleId = studentRole.Id,
                    IsActive = true,
                    CreatedAt = DateTime.UtcNow,
                    Address = "aaa",
                    Age = 50,
                    PhoneOne = "7788977",
                    PhoneTow = "88559999",
                    Sex = true,
                }
            };
            await context.Users.AddRangeAsync(users);
            await context.SaveChangesAsync();

            // Create Levels
            var levels = new List<Level>
            {
                new Level { LevelName = "First Year", DepartmentId = departments[0].Id, IsActive = true },
                new Level { LevelName = "Second Year", DepartmentId = departments[0].Id, IsActive = true },
                new Level { LevelName = "Third Year", DepartmentId = departments[0].Id, IsActive = true },
                new Level { LevelName = "Fourth Year", DepartmentId = departments[0].Id, IsActive = true },
                new Level { LevelName = "سنة اولأ ترم أول", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة اولأ ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة ثانية ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة ثانية ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة ثالثة ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة ثالثة ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة رابعة ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Level { LevelName = "سنة رابعة ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
            };
            await context.Levels.AddRangeAsync(levels);
            await context.SaveChangesAsync();

            // Create Student
            var student = new Student
            {
                UserId = users.First(u => u.Email == "mohmdAlsnbany@example.com").Id,
                DepartmentId = departments[3].Id,
                LevelId = levels[4].Id,
                EnrollmentYear = DateTime.Now.Year,
                IsActive = true,
                AcademicId = DateTime.Now.Year.ToString() + "|" + users.First(u => u.Email == "mohmdAlsnbany@example.com").Id.ToString(),

            };
            await context.Students.AddAsync(student);
            await context.SaveChangesAsync();
            var student2 = new Student
            {
                UserId = users.First(u => u.Email == "ahmed@example.com").Id,
                DepartmentId = departments[3].Id,
                LevelId = levels[8].Id,
                EnrollmentYear = DateTime.Now.Year,
                IsActive = true,
                AcademicId = DateTime.Now.Year.ToString() + "|" + users.First(u => u.Email == "ahmed@example.com").Id.ToString(),

            };
            await context.Students.AddAsync(student2);
            await context.SaveChangesAsync();

            // Create Subjects
            var subjects = new List<Subject>
            {
                new Subject { SubjectName = "Programming Fundamentals", Description = "Basic programming concepts", IsActive = true },
                new Subject { SubjectName = "Data Structures", Description = "Basic data structures", IsActive = true },
                new Subject { SubjectName = "Database Systems", Description = "Database concepts and SQL Part One", IsActive = true },
                new Subject { SubjectName = "Database Systems", Description = "Database concepts and SQL Part Tow", IsActive = true },
                new Subject { SubjectName = "Database Systems", Description = "Database concepts and SQL Part Three", IsActive = true },
                new Subject { SubjectName = "Database Systems", Description = "Database concepts and SQL Part For", IsActive = true },
                new Subject { SubjectName = "لغة عربية", Description = "لغة عربية الجزء الأول", IsActive = true },
                new Subject { SubjectName = "لغة عربية", Description = "لغة عربية الجزء الثاني", IsActive = true },
                new Subject { SubjectName = "رياضيات", Description = "رياضيات الجزء الأول", IsActive = true },
                new Subject { SubjectName = "رياضيات", Description = "رياضيات الجزء الثاني", IsActive = true },
                new Subject { SubjectName = "C# Console", Description = "C# Console commitw", IsActive = true },
                new Subject { SubjectName = "C# Form", Description = "C# Form Drag-Drop", IsActive = true },
            };
            await context.Subjects.AddRangeAsync(subjects);
            await context.SaveChangesAsync();

            // Create Courses
            var courses = new List<Course>
            {
                new Course { CourseName = "CS101", Description = "Introduction to Programming", DepartmentId = departments[0].Id, IsActive = true },
                new Course { CourseName = "CS102", Description = "Data Structures and Algorithms", DepartmentId = departments[0].Id, IsActive = true },
                new Course { CourseName = "CS103", Description = "Database Systems", DepartmentId = departments[0].Id, IsActive = true },
                new Course { CourseName = "ITFirstYearePart1", Description = "تقنية معلومات سنة اولأ ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITFirstYearePart2", Description = "تقنية معلومات سنة اولأ ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITSecondYearePart1", Description = "تقنية معلومات سنة ثانية ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITSecondYearePart2", Description = "تقنية معلومات سنة ثانية ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITTheerdYearePart1", Description = "تقنية معلومات سنة ثالثة ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITTheerdYearePart2", Description = "تقنية معلومات سنة ثالثة ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITForthYearePart1", Description = "تقنية معلومات سنة رابعة ترم اول", DepartmentId = departments[3].Id, IsActive = true },
                new Course { CourseName = "ITForthYearePart2", Description = "تقنية معلومات سنة رابعة ترم ثاني", DepartmentId = departments[3].Id, IsActive = true },
            };
            await context.Courses.AddRangeAsync(courses);
            await context.SaveChangesAsync();

            // Create CourseSubjects
            var courseSubjects = new List<CourseSubject>
            {
                new CourseSubject { CourseId = courses[0].Id, SubjectId = subjects[0].Id, LevelId = levels[0].Id , },
                new CourseSubject { CourseId = courses[1].Id, SubjectId = subjects[1].Id, LevelId = levels[1].Id },
                new CourseSubject { CourseId = courses[2].Id, SubjectId = subjects[2].Id, LevelId = levels[2].Id },
                // سنة اولا
                new CourseSubject { CourseId = courses[3].Id, SubjectId = subjects[6].Id, LevelId = levels[4].Id },
                new CourseSubject { CourseId = courses[3].Id, SubjectId = subjects[8].Id, LevelId = levels[4].Id },
                new CourseSubject { CourseId = courses[4].Id, SubjectId = subjects[7].Id, LevelId = levels[5].Id },
                new CourseSubject { CourseId = courses[4].Id, SubjectId = subjects[9].Id, LevelId = levels[5].Id },
                // سنة ثانية
                new CourseSubject { CourseId = courses[5].Id, SubjectId = subjects[10].Id, LevelId = levels[6].Id },
                new CourseSubject { CourseId = courses[6].Id, SubjectId = subjects[11].Id, LevelId = levels[7].Id },
                // سنة ثالثة
                new CourseSubject { CourseId = courses[7].Id, SubjectId = subjects[2].Id, LevelId = levels[8].Id },
                new CourseSubject { CourseId = courses[8].Id, SubjectId = subjects[3].Id, LevelId = levels[9].Id },
                // سنة رابعة
                new CourseSubject { CourseId = courses[9].Id, SubjectId = subjects[4].Id, LevelId = levels[10].Id },
                new CourseSubject { CourseId = courses[10].Id, SubjectId = subjects[5].Id, LevelId = levels[11].Id },
            };
            await context.CourseSubjects.AddRangeAsync(courseSubjects);
            await context.SaveChangesAsync();

            // Create DoctorDepartmentsLevels
            var doctorDepartmentsLevels = new List<DoctorDepartmentsLevels>
            {
                new DoctorDepartmentsLevels
                {
                    Id = 0,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    DepartmentId = departments[0].Id,
                    LevelId = levels[0].Id,
                    IsActive = true
                },
                new DoctorDepartmentsLevels
                {
                    Id = 0,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId = levels[0].Id,
                    IsActive = true
                }
            };
            await context.DoctorDepartmentsLevels.AddRangeAsync(doctorDepartmentsLevels);
            await context.SaveChangesAsync();

            // Create LectureSchedules
            var lectureSchedules = new List<LectureSchedule>
            {
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[9].Id,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId = courseSubjects[9].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "301",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[10].Id,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId = courseSubjects[10].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "302",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[11].Id,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId =  courseSubjects[11].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "401",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[12].Id,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId =  courseSubjects[12].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "402",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[3].Id,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId = courseSubjects[3].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "101",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[4].Id,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId =  courseSubjects[4].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "102",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[5].Id,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId =  courseSubjects[5].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "201",
                    IsActive = true
                },
                new LectureSchedule
                {
                    CourseSubjectId = courseSubjects[6].Id,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    DepartmentId = departments[3].Id,
                    LevelId = courseSubjects[6].LevelId,
                    DayOfWeek = DayOfWeek.Monday,
                    StartTime = new TimeSpan(9, 0, 0),
                    EndTime = new TimeSpan(10, 30, 0),
                    Room = "202",
                    IsActive = true,
                    
                }
            };
            await context.LectureSchedules.AddRangeAsync(lectureSchedules);
            await context.SaveChangesAsync();

            // Create QRCodes
            var qrCodes = new List<QRCode>
            {
                new QRCode
                {
                    QRCodeValue = Guid.NewGuid().ToString(),
                    ScheduleId = lectureSchedules[4].Id,
                    DoctorId = users.First(u => u.Email == "ebrahim@example.com").Id,
                    GeneratedAt = DateTime.Now.AddDays(7),
                    ExpiresAt = DateTime.Now.AddHours(3),
                    IsActive = true
                },
                new QRCode
                {
                    QRCodeValue = Guid.NewGuid().ToString(),
                    ScheduleId = lectureSchedules[0].Id,
                    DoctorId = users.First(u => u.Email == "mohdAljodah@example.com").Id,
                    GeneratedAt = DateTime.Now,
                    ExpiresAt = DateTime.Now.AddHours(1),
                    IsActive = true
                }
            };
            await context.QRCodes.AddRangeAsync(qrCodes);
            await context.SaveChangesAsync();

            // Create Attendances
            var attendances = new List<Attendance>
            {
                new Attendance
                {
                    StudentId = student.Id,
                    ScheduleId = lectureSchedules[0].Id,
                    QRCodeId = qrCodes[1].Id,
                    AttendanceDate = DateTime.Now,
                    Status = true,  // true for Present
                    StudentNote = "On time",
                    DoctorNote = "Present"
                },
                new Attendance
                {
                    StudentId = student2.Id,
                    ScheduleId = lectureSchedules[4].Id,
                    QRCodeId = qrCodes[0].Id,
                    AttendanceDate = DateTime.Now,
                    Status = true,  // true for Present
                    StudentNote = "On time",
                    DoctorNote = "Present"
                }
            };
            await context.Attendances.AddRangeAsync(attendances);
            await context.SaveChangesAsync();
        }
    }
}