import 'package:coordinator_dashpord_for_studentmark/features/users/presentation/screens/users_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'features/auth/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/screens/coordinator_dashboard_screen.dart';
import 'package:coordinator_dashpord_for_studentmark/features/students/presentation/screens/students_management_screen.dart';
import 'package:coordinator_dashpord_for_studentmark/features/students/presentation/screens/student_attendance_screen.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/presentation/screens/departments_management_screen.dart';

import 'features/doctors/domain/repositories/doctor_repository.dart';
import 'features/levels/presentation/screens/levels_management_screen.dart';
import 'features/subjects/presentation/screens/subjects_management_screen.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/screens/lecture_schedules_management_screen.dart';
import 'package:coordinator_dashpord_for_studentmark/features/courses/presentation/pages/courses_page.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/data/repositories/doctor_repository_impl.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/data/services/doctor_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/providers/doctor_provider.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/screens/doctors_management_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(
            create: (_) =>
                AuthService(ApiService(), const FlutterSecureStorage())),
        Provider<DoctorService>(
          create: (context) => DoctorService(
            Dio(),
            baseUrl: 'http://192.168.137.1:7275',
          ),
        ),
        Provider<DoctorRepository>(
          create: (context) => DoctorRepositoryImpl(
            context.read<DoctorService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DoctorProvider(
            context.read<DoctorRepository>(),
            context.read<DoctorService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Dio with base options
    final dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.137.1:7275', // Replace with your API base URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    // Initialize CoordinatorService
    final coordinatorService = CoordinatorService(
      dio,
      baseUrl: 'http://192.168.137.1:7275', // Replace with your API base URL
    );

    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(
            create: (_) =>
                AuthService(ApiService(), const FlutterSecureStorage())),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar', 'AR'),
        supportedLocales: AppConstants.supportedLocales,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: AppTheme.responsiveBreakpoints,
        ),
        home: CoordinatorDashboardScreen(
          coordinatorService: coordinatorService,
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/user': (context) => UsersManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/dashboard': (context) => CoordinatorDashboardScreen(
                coordinatorService: coordinatorService,
              ),
          '/students': (context) => StudentsManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/student-attendance': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return StudentAttendanceScreen(
              coordinatorService: coordinatorService,
              studentId: args['studentId'],
            );
          },
          '/departments': (context) => DepartmentsManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/levels': (context) => LevelsManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/subjects': (context) => SubjectsManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/lecture-schedules': (context) => LectureSchedulesManagementScreen(
                coordinatorService: coordinatorService,
              ),
          '/courses': (context) => CoursesPage(
                coordinatorService: coordinatorService,
              ),
          '/doctors': (context) => const DoctorsManagementScreen(),
          // Add other routes here
        },
      ),
    );
  }
}
