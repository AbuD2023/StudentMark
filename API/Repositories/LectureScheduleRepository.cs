using API.Data;
using API.DTOs;
using API.Entities;
using API.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace API.Repositories
{
    public class LectureScheduleRepository : GenericRepository<LectureSchedule>, ILectureScheduleRepository
    {
        public LectureScheduleRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDoctorAsync(int doctorId)
        {
            return await _context.LectureSchedules
                .Where(s => s.DoctorId == doctorId && s.IsActive)
                //.Include(s => s.CourseSubject)
                //    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                //.Include(s => s.Subject)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseSubjectAsync(int courseSubjectId)
        {
            return await _context.LectureSchedules
                .Where(s => s.CourseSubjectId == courseSubjectId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByCourseAsync(int courseId)
        {
            return await _context.LectureSchedules
                .Where(s => s.CourseSubject.CourseId == courseId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDepartmentAsync(int departmentId)
        {
            return await _context.LectureSchedules
                .Where(s => s.DepartmentId == departmentId && s.IsActive)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByLevelAsync(int levelId)
        {
            //var data =
                return await _context.LectureSchedules
                .Where(s => s.LevelId == levelId && s.IsActive)
                //.Include(s => s.CourseSubject)
                //    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                //.Include(s => s.Doctor)
                .Include(s => s.Level)
                .ToListAsync();

            //List<LectureSchedule> dataR = [];
            //foreach (var elemnt in data)
            //{
            //    var courseSubject = new CourseSubject
            //    {
            //        Id = elemnt.CourseSubject.Id,
            //        CourseId = elemnt.CourseSubject.CourseId,
            //        SubjectId = elemnt.CourseSubject.SubjectId,
            //        LevelId = elemnt.CourseSubject.LevelId,
            //        IsActive = elemnt.CourseSubject.IsActive,
            //        Subject = elemnt.CourseSubject.Subject,
            //        Course = null,
            //        LectureSchedules = null,
            //        Level = null,
            //    };
            //    var department = new Department
            //    {
            //        Id = elemnt.Department.Id,
            //        DepartmentName = elemnt.Department.DepartmentName,
            //        Description = elemnt.Department.Description,
            //        IsActive = elemnt.Department.IsActive,
            //        Courses = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Levels = null,
            //        Students = null,
            //    };
            //    var doctor = new User
            //    {
            //        Id = elemnt.Doctor.Id,
            //        FullName = elemnt.Doctor.FullName,
            //        RefreshToken = elemnt.Doctor.RefreshToken,
            //        Username = elemnt.Doctor.Username,
            //        PasswordHash = elemnt.Doctor.PasswordHash,
            //        Email = elemnt.Doctor.Email,
            //        Password = elemnt.Doctor.Password,
            //        IsActive = elemnt.Doctor.IsActive,
            //        CreatedAt = elemnt.Doctor.CreatedAt,
            //        RefreshTokenExpiryTime = elemnt.Doctor.RefreshTokenExpiryTime,
            //        LastLoginAt = elemnt.Doctor.LastLoginAt,
            //        RoleId = elemnt.Doctor.RoleId,
            //        DoctorDepartmentsLevels = null,
            //        Attendances = null,
            //        GeneratedQRCodes = null,
            //        LectureSchedules = null,
            //        Role = null,
            //        Student = null,
            //    };
            //    var level = new Level
            //    {
            //        Id = elemnt.Level.Id,
            //        LevelName = elemnt.Level.LevelName,
            //        DepartmentId = elemnt.Level.DepartmentId,
            //        IsActive = elemnt.Level.IsActive,
            //        CourseSubjects = null,
            //        Department = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Students = null,
            //    };
            //    var lectureSchedule = new LectureSchedule
            //    {
            //        Id = elemnt.Id,
            //        CourseSubjectId = elemnt.CourseSubjectId,
            //        DoctorId = elemnt.DoctorId,
            //        DepartmentId = elemnt.DepartmentId,
            //        LevelId = elemnt.LevelId,
            //        DayOfWeek = elemnt.DayOfWeek,
            //        StartTime = elemnt.StartTime,
            //        EndTime = elemnt.EndTime,
            //        Room = elemnt.Room,
            //        IsActive = elemnt.IsActive,
            //        CourseId = elemnt.CourseId,
            //        SubjectId = elemnt.SubjectId,
            //        CourseSubject = courseSubject,
            //        Department = elemnt.Department,
            //        Doctor = doctor,
            //        Level = level,
            //        Attendances = null,
            //        Course = null,
            //        QRCodes = null,
            //        Subject = null,
            //    };
            //    dataR.Add(lectureSchedule);
            //}
            //return dataR;
        }

        public async Task<IEnumerable<LectureSchedule>> GetSchedulesByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.LectureSchedules
                .Where(s => s.DayOfWeek == ((DayOfWeek)startDate.Day))
                //.Include(s => s.CourseSubject)
                //    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                .Include(s => s.Department)
                //.Include(s => s.Doctor)
                .Include(s => s.Level)
                .ToListAsync();
        }

        public async Task<IEnumerable<LectureSchedule>> GetActiveSchedulesAsync()
        {
            //var data = 
             return   await _context.LectureSchedules
                .Where(s => s.IsActive)
                //.Include(s => s.CourseSubject)
                //    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                //.Include(s => s.Doctor)
                    //.ThenInclude(cs => cs.DoctorDepartmentsLevels)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
            //List<LectureSchedule> dataR = [];
            //foreach(var elemnt in data)
            //{
            //    var courseSubject =new CourseSubject{ 
            //        Id =elemnt.CourseSubject.Id,
            //        CourseId = elemnt.CourseSubject.CourseId,
            //        SubjectId = elemnt.CourseSubject.SubjectId,
            //        LevelId = elemnt.CourseSubject.LevelId,
            //        IsActive = elemnt.CourseSubject.IsActive,
            //        Subject = elemnt.CourseSubject.Subject,
            //        Course = null,
            //        LectureSchedules = null,
            //        Level = null,
            //    };
            //    var department = new Department{
            //        Id = elemnt.Department.Id,
            //        DepartmentName = elemnt.Department.DepartmentName,
            //        Description = elemnt.Department.Description,
            //        IsActive = elemnt.Department.IsActive,
            //        Courses = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Levels = null,
            //        Students = null,
            //    };
            //    //var doctor = new User{
            //    //    Id = elemnt.Doctor.Id,
            //    //    FullName = elemnt.Doctor.FullName,
            //    //    RefreshToken = elemnt.Doctor.RefreshToken,
            //    //    Username = elemnt.Doctor.Username,
            //    //    PasswordHash = elemnt.Doctor.PasswordHash,
            //    //    Email = elemnt.Doctor.Email,
            //    //    Password = elemnt.Doctor.Password,
            //    //    IsActive = elemnt.Doctor.IsActive,
            //    //    CreatedAt = elemnt.Doctor.CreatedAt,
            //    //    RefreshTokenExpiryTime = elemnt.Doctor.RefreshTokenExpiryTime,
            //    //    LastLoginAt = elemnt.Doctor.LastLoginAt,
            //    //    RoleId = elemnt.Doctor.RoleId,
            //    //    DoctorDepartmentsLevels = null,
            //    //    Attendances = null,
            //    //    GeneratedQRCodes = null,
            //    //    LectureSchedules = null,
            //    //    Role = null,
            //    //    Student = null,
            //    //};
            //    var level = new Level{
            //        Id = elemnt.Level.Id,
            //        LevelName = elemnt.Level.LevelName,
            //        DepartmentId = elemnt.Level.DepartmentId,
            //        IsActive = elemnt.Level.IsActive,
            //        CourseSubjects = null,
            //        Department = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Students = null,
            //    };
            //    var lectureSchedule = new LectureSchedule{ 
            //        Id = elemnt.Id,
            //        CourseSubjectId = elemnt.CourseSubjectId,
            //        DoctorId = elemnt.DoctorId,
            //        DepartmentId = elemnt.DepartmentId,
            //        LevelId = elemnt.LevelId,
            //        DayOfWeek = elemnt.DayOfWeek,
            //        StartTime = elemnt.StartTime,
            //        EndTime = elemnt.EndTime,
            //        Room = elemnt.Room,
            //        IsActive = elemnt.IsActive,
            //        CourseId = elemnt.CourseId,
            //        SubjectId = elemnt.SubjectId,
            //        CourseSubject = courseSubject,
            //        Department = elemnt.Department,
            //        Doctor = null,
            //        //Doctor = doctor,
            //        Level = level,
            //        Attendances = null,
            //        Course = null,
            //        QRCodes = null,
            //        Subject = null,
            //    };
            //    dataR.Add(lectureSchedule);
            //}
            //return dataR;
        }

        public async Task<IEnumerable<RoomDto>> GetAllRoomsAsync()
        {

            return  await _context.LectureSchedules.Where(l => l.IsActive)
                .Select(x => new RoomDto
                {
                    Id = x.Id,
                    Room = x.Room,
                }).ToArrayAsync();
        }
        public async Task<IEnumerable<LectureSchedule>> GetAllSchedulesAsync()
        {
            //var data =  
            return await _context.LectureSchedules
                //.Include(s => s.CourseSubject)
                //    .ThenInclude(cs => cs.Course)
                .Include(s => s.CourseSubject)
                    .ThenInclude(cs => cs.Subject)
                //.Include(s => s.Doctor)
                    //.ThenInclude(cs => cs.DoctorDepartmentsLevels)
                .Include(s => s.Department)
                .Include(s => s.Level)
                .ToListAsync();
            //List<LectureSchedule> dataR = [];
            //foreach (var elemnt in data)
            //{
            //    var courseSubject = new CourseSubject
            //    {
            //        Id = elemnt.CourseSubject.Id,
            //        CourseId = elemnt.CourseSubject.CourseId,
            //        SubjectId = elemnt.CourseSubject.SubjectId,
            //        LevelId = elemnt.CourseSubject.LevelId,
            //        IsActive = elemnt.CourseSubject.IsActive,
            //        Subject = elemnt.CourseSubject.Subject,
            //        Course = null,
            //        LectureSchedules = null,
            //        Level = null,
            //    };
            //    var department = new Department
            //    {
            //        Id = elemnt.Department.Id,
            //        DepartmentName = elemnt.Department.DepartmentName,
            //        Description = elemnt.Department.Description,
            //        IsActive = elemnt.Department.IsActive,
            //        Courses = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Levels = null,
            //        Students = null,
            //    };
            //    //var doctor = new User
            //    //{
            //    //    Id = elemnt.Doctor.Id,
            //    //    FullName = elemnt.Doctor.FullName,
            //    //    RefreshToken = elemnt.Doctor.RefreshToken,
            //    //    Username = elemnt.Doctor.Username,
            //    //    PasswordHash = elemnt.Doctor.PasswordHash,
            //    //    Email = elemnt.Doctor.Email,
            //    //    Password = elemnt.Doctor.Password,
            //    //    IsActive = elemnt.Doctor.IsActive,
            //    //    CreatedAt = elemnt.Doctor.CreatedAt,
            //    //    RefreshTokenExpiryTime = elemnt.Doctor.RefreshTokenExpiryTime,
            //    //    LastLoginAt = elemnt.Doctor.LastLoginAt,
            //    //    RoleId = elemnt.Doctor.RoleId,
            //    //    DoctorDepartmentsLevels = null,
            //    //    Attendances = null,
            //    //    GeneratedQRCodes = null,
            //    //    LectureSchedules = null,
            //    //    Role = null,
            //    //    Student = null,
            //    //};
            //    var level = new Level
            //    {
            //        Id = elemnt.Level.Id,
            //        LevelName = elemnt.Level.LevelName,
            //        DepartmentId = elemnt.Level.DepartmentId,
            //        IsActive = elemnt.Level.IsActive,
            //        CourseSubjects = null,
            //        Department = null,
            //        DoctorDepartmentsLevels = null,
            //        LectureSchedules = null,
            //        Students = null,
            //    };
            //    var lectureSchedule = new LectureSchedule
            //    {
            //        Id = elemnt.Id,
            //        CourseSubjectId = elemnt.CourseSubjectId,
            //        DoctorId = elemnt.DoctorId,
            //        DepartmentId = elemnt.DepartmentId,
            //        LevelId = elemnt.LevelId,
            //        DayOfWeek = elemnt.DayOfWeek,
            //        StartTime = elemnt.StartTime,
            //        EndTime = elemnt.EndTime,
            //        Room = elemnt.Room,
            //        IsActive = elemnt.IsActive,
            //        CourseId = elemnt.CourseId,
            //        SubjectId = elemnt.SubjectId,
            //        CourseSubject = courseSubject,
            //        Department = elemnt.Department,
            //        Doctor = null,
            //        //Doctor = doctor,
            //        Level = level,
            //        Attendances = null,
            //        Course = null,
            //        QRCodes = null,
            //        Subject = null,
            //    };
            //    dataR.Add(lectureSchedule);
            //}
            //return dataR;
        }

        public async Task<bool> IsTimeSlotAvailableAsync(int doctorId, int LectureScheduleId, DayOfWeek dayOfWeek, TimeSpan startTime, TimeSpan endTime)
        {
            return !await _context.LectureSchedules
                .AnyAsync(s =>( s.DoctorId == doctorId &&
                                s.DayOfWeek == dayOfWeek &&
                                s.IsActive &&
                                ( (s.StartTime <= startTime && s.EndTime > startTime) ||
                                  (s.StartTime < endTime && s.EndTime >= endTime) ||
                                  (s.StartTime >= startTime && s.EndTime <= endTime)) )&&
                                   s.Id != LectureScheduleId 
                              );
        }
    }
}