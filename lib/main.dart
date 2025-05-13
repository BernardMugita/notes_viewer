import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/providers/activity_provider.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/router/router.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/views/splash/splash_screen.dart';
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
  final activityProvider = ActivityProvider();
  final themeProvider = ThemeProvider();

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
        ChangeNotifierProvider(create: (_) => activityProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
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
        activityProvider: activityProvider,
        themeProvider: themeProvider,
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
  final ActivityProvider activityProvider;
  final ThemeProvider themeProvider;

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
    required this.activityProvider,
    required this.themeProvider,
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
        colorScheme: Provider.of<ThemeProvider>(context).isDarkMode
            ? ColorScheme.dark(primary: AppUtils.mainBlack(context))
            : ColorScheme.light(primary: AppUtils.mainWhite(context)),
        useMaterial3: true,
        fontFamily: 'Jost',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
