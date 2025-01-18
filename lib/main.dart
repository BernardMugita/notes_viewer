import 'package:flutter/material.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/router/router.dart'; // Make sure to import this
import 'package:note_viewer/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  final toggleProvider = TogglesProvider();
  final lessonsProvider = LessonsProvider();
  final coursesProvider = CoursesProvider();
  final unitsProvider = UnitsProvider();
  final userProvider = UserProvider();

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
        ChangeNotifierProvider(create: (_) => lessonsProvider)
      ],
      child: MyApp(
        authProvider: authProvider,
        toggleProvider: toggleProvider,
        lessonsProvider: lessonsProvider,
        coursesProvider: coursesProvider,
        unitsProvider: unitsProvider,
        userProvider: userProvider,
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

  const MyApp({
    super.key,
    required this.authProvider,
    required this.toggleProvider,
    required this.lessonsProvider,
    required this.coursesProvider,
    required this.unitsProvider,
    required this.userProvider,
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
