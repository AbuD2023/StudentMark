class AppConstants {
  // API Base URL
  static const String baseUrl = 'http://192.168.137.1:7275/api';

  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String departments = '/department';
  static const String levels = '/level';
  static const String subjects = '/subject';
  static const String courses = '/course';
  static const String students = '/student';
  static const String doctors = '/doctor';
  static const String schedules = '/LectureSchedule';
  static const String attendances = '/Attendance';
  static const String reports = '/AttendanceReport';
  static const String excelImport = '/ExcelImport';
  static const String lectureSchedules = '/lecture-schedule';
  static const String qrcodes = '/QRCode';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // App Constants
  static const String appName = 'Academic Coordinator Dashboard';
  static const String appVersion = '1.0.0';

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Default Sizes
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultIconSize = 24.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
