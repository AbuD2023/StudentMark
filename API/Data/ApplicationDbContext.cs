using API.Entities;
using Microsoft.EntityFrameworkCore;

namespace API.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Permission> Permissions { get; set; }
        public DbSet<RolePermission> RolePermissions { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<Level> Levels { get; set; }
        public DbSet<Course> Courses { get; set; }
        public DbSet<Subject> Subjects { get; set; }
        public DbSet<CourseSubject> CourseSubjects { get; set; }
        public DbSet<LectureSchedule> LectureSchedules { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<QRCode> QRCodes { get; set; }
        public DbSet<Attendance> Attendances { get; set; }
        public DbSet<DoctorDepartmentsLevels> DoctorDepartmentsLevels { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure composite keys
            modelBuilder.Entity<RolePermission>()
                .HasKey(rp => new { rp.RoleId, rp.PermissionId });

            modelBuilder.Entity<DoctorDepartmentsLevels>()
                .HasKey(ddl => new { ddl.DoctorId, ddl.DepartmentId, ddl.LevelId });

            // Configure relationships with NO ACTION for delete behavior
            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany(r => r.Users)
                .HasForeignKey(u => u.RoleId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Student>()
                .HasOne(s => s.User)
                .WithOne(u => u.Student)
                .HasForeignKey<Student>(s => s.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure CourseSubjects relationships
            modelBuilder.Entity<CourseSubject>()
                .HasOne(cs => cs.Course)
                .WithMany(c => c.CourseSubjects)
                .HasForeignKey(cs => cs.CourseId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<CourseSubject>()
                .HasOne(cs => cs.Subject)
                .WithMany(s => s.CourseSubjects)
                .HasForeignKey(cs => cs.SubjectId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<CourseSubject>()
                .HasOne(cs => cs.Level)
                .WithMany(l => l.CourseSubjects)
                .HasForeignKey(cs => cs.LevelId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure Levels relationship
            modelBuilder.Entity<Level>()
                .HasOne(l => l.Department)
                .WithMany(d => d.Levels)
                .HasForeignKey(l => l.DepartmentId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure Courses relationship
            modelBuilder.Entity<Course>()
                .HasOne(c => c.Department)
                .WithMany(d => d.Courses)
                .HasForeignKey(c => c.DepartmentId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure QRCode relationships
            modelBuilder.Entity<QRCode>()
                .HasOne(q => q.Doctor)
                .WithMany(u => u.GeneratedQRCodes)
                .HasForeignKey(q => q.DoctorId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<QRCode>()
                .HasOne(q => q.LectureSchedule)
                .WithMany(l => l.QRCodes)
                .HasForeignKey(q => q.ScheduleId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure LectureSchedule relationships
            modelBuilder.Entity<LectureSchedule>()
                .HasOne(l => l.Doctor)
                .WithMany(u => u.LectureSchedules)
                .HasForeignKey(l => l.DoctorId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<LectureSchedule>()
                .HasOne(l => l.Department)
                .WithMany(d => d.LectureSchedules)
                .HasForeignKey(l => l.DepartmentId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<LectureSchedule>()
                .HasOne(l => l.Level)
                .WithMany(l => l.LectureSchedules)
                .HasForeignKey(l => l.LevelId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<LectureSchedule>()
                .HasOne(l => l.CourseSubject)
                .WithMany(cs => cs.LectureSchedules)
                .HasForeignKey(l => l.CourseSubjectId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure Student relationships
            modelBuilder.Entity<Student>()
                .HasOne(s => s.Department)
                .WithMany(d => d.Students)
                .HasForeignKey(s => s.DepartmentId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Student>()
                .HasOne(s => s.Level)
                .WithMany(l => l.Students)
                .HasForeignKey(s => s.LevelId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure DoctorDepartmentsLevels relationships
            modelBuilder.Entity<DoctorDepartmentsLevels>()
                .HasOne(ddl => ddl.Doctor)
                .WithMany(u => u.DoctorDepartmentsLevels)
                .HasForeignKey(ddl => ddl.DoctorId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<DoctorDepartmentsLevels>()
                .HasOne(ddl => ddl.Department)
                .WithMany(d => d.DoctorDepartmentsLevels)
                .HasForeignKey(ddl => ddl.DepartmentId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<DoctorDepartmentsLevels>()
                .HasOne(ddl => ddl.Level)
                .WithMany(l => l.DoctorDepartmentsLevels)
                .HasForeignKey(ddl => ddl.LevelId)
                .OnDelete(DeleteBehavior.NoAction);

            // Configure Attendance relationships
            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.Student)
                .WithMany(s => s.Attendances)
                .HasForeignKey(a => a.StudentId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.LectureSchedule)
                .WithMany(l => l.Attendances)
                .HasForeignKey(a => a.ScheduleId)
                .OnDelete(DeleteBehavior.NoAction);

            modelBuilder.Entity<Attendance>()
                .HasOne(a => a.QRCode)
                .WithMany(q => q.Attendances)
                .HasForeignKey(a => a.QRCodeId)
                .OnDelete(DeleteBehavior.NoAction);

            // Add indexes for better performance
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<QRCode>()
                .HasIndex(q => q.QRCodeValue)
                .IsUnique();

            modelBuilder.Entity<Attendance>()
                .HasIndex(a => new { a.StudentId, a.ScheduleId, a.AttendanceDate })
                .IsUnique();
        }
    }
}