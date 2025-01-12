import 'package:flutter/material.dart';
import 'package:note_viewer/providers/courses_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/auth/course/course_view.dart';
import 'package:note_viewer/views/auth/login/login_view.dart';
import 'package:note_viewer/views/dashboard/desktop_dashboard.dart';
import 'package:note_viewer/views/dashboard/mobile_dashboard.dart';
import 'package:note_viewer/views/dashboard/tablet_dashboard.dart';
import 'package:note_viewer/views/notes/notes_view.dart';
import 'package:note_viewer/views/study/study_view.dart';
import 'package:note_viewer/views/units/units_view.dart';
import 'package:note_viewer/views/view_notes/view_notes_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.checkLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => TogglesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CoursesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UnitsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Future<void> _loadPreferences;

  @override
  void initState() {
    super.initState();
    _loadPreferences = Provider.of<TogglesProvider>(context, listen: false)
        .loadRememberSelection(); // Initialize the loading of preferences
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final togglesProvider = Provider.of<TogglesProvider>(context);

    return FutureBuilder(
      future: _loadPreferences,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading screen while preferences are being loaded
          return MaterialApp(
            title: 'Note Viewer',
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final isAuthenticated = authProvider.isAuthenticated;
        final isRememberSelection = togglesProvider.rememberSelection;

        return MaterialApp(
          title: 'Note Viewer',
          home: Builder(builder: (context) {
            if (isAuthenticated) {
              return isRememberSelection
                  ? const MyHomePage(title: 'Note Viewer')
                  : const CourseView();
            } else {
              return const LoginView();
            }
          }),
          routes: {
            '/login': (context) => const LoginView(),
            '/course': (context) => isRememberSelection
                ? const MyHomePage(title: 'Note Viewer')
                : const CourseView(),
            '/units': (context) =>
                isAuthenticated ? const UnitsView() : const LoginView(),
            '/units/notes': (context) =>
                isAuthenticated ? const NotesView() : const LoginView(),
          },
          onGenerateRoute: (settings) {
            final uri = Uri.parse(settings.name ?? '');

            if (!authProvider.isAuthenticated) {
              return MaterialPageRoute(
                builder: (context) => const LoginView(),
              );
            }

            // Existing route handling logic
            if (uri.pathSegments.length == 3 &&
                uri.pathSegments[0] == 'units' &&
                uri.pathSegments[1] == 'study') {
              final lessonName = uri.pathSegments[2];

              return MaterialPageRoute(
                builder: (context) => const StudyView(),
                settings: RouteSettings(
                  name: settings.name,
                  arguments: lessonName,
                ),
              );
            }

            if (uri.pathSegments.length == 4 &&
                uri.pathSegments[0] == 'units' &&
                uri.pathSegments[1] == 'study') {
              final lessonName = uri.pathSegments[2];
              final fileName = uri.pathSegments[3];

              return MaterialPageRoute(
                builder: (context) => ViewNotesView(),
                settings: RouteSettings(
                  name: settings.name,
                  arguments: {
                    'lessonName': lessonName,
                    'fileName': fileName,
                  },
                ),
              );
            }

            return null;
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF2A68AF)),
            useMaterial3: true,
            fontFamily: 'Jost',
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileLayout: MobileDashboard(),
        tabletLayout: TabletDashboard(),
        desktopLayout: DesktopDashboard(),
      ),
    );
  }
}
