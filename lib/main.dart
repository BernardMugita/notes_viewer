import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/dashboard_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/uploads_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/router/router.dart'; // Make sure to import this
import 'package:note_viewer/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _requestPermissions() async {
  if (kIsWeb) {
    return;
  }

  // For mobile platforms, request storage permission
  final status = await Permission.storage.request();
  if (!status.isGranted) {
    // Handle the case where the permission is denied
    print("Permission denied");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  final toggleProvider = TogglesProvider();
  final lessonsProvider = LessonsProvider();
  final coursesProvider = CoursesProvider();
  final unitsProvider = UnitsProvider();
  final userProvider = UserProvider();
  final uploadsProvider = UploadsProvider();
  final dashboardProvider = DashboardProvider();

  // Request permissions (only on mobile platforms)
  await _requestPermissions();

  // Load initial state for providers
  await authProvider.checkLogin();
  await toggleProvider.loadRememberSelection();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => toggleProvider),
        ChangeNotifierProvider(create: (_) => coursesProvider),
        ChangeNotifierProvider(create: (_) => unitsProvider),
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => lessonsProvider),
        ChangeNotifierProvider(create: (_) => uploadsProvider),
        ChangeNotifierProvider(create: (_) => dashboardProvider),
      ],
      child: MyApp(
        authProvider: authProvider,
        toggleProvider: toggleProvider,
        lessonsProvider: lessonsProvider,
        coursesProvider: coursesProvider,
        unitsProvider: unitsProvider,
        userProvider: userProvider,
        uploadsProvider: uploadsProvider,
        dashboardProvider: dashboardProvider,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final TogglesProvider toggleProvider;
  final LessonsProvider lessonsProvider;
  final CoursesProvider coursesProvider;
  final UnitsProvider unitsProvider;
  final UserProvider userProvider;
  final UploadsProvider uploadsProvider;
  final DashboardProvider dashboardProvider;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.toggleProvider,
    required this.lessonsProvider,
    required this.coursesProvider,
    required this.unitsProvider,
    required this.userProvider,
    required this.uploadsProvider,
    required this.dashboardProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (authProvider.isLoading || toggleProvider.isLoading) {
      return MaterialApp(
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    }

    final router = createRouter(authProvider, toggleProvider, userProvider,
        unitsProvider, coursesProvider, lessonsProvider);

    return MaterialApp.router(
      title: 'Note Viewer',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A68AF)),
        useMaterial3: true,
        fontFamily: 'Jost',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
