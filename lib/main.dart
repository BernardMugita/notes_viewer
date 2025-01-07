import 'package:flutter/material.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/auth_provider.dart';
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

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..checkLogin(),
        ),
        ChangeNotifierProvider(
          create: (context) => TogglesProvider(),
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
    return MaterialApp(
      title: 'Note Viewer',
      initialRoute:
          Provider.of<AuthProvider>(context, listen: false).isAuthenticated
              ? '/'
              : '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/course': (context) => const CourseView(),
        '/units': (context) => const UnitsView(),
        '/units/notes': (context) => const NotesView(),
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');

        // /units/study/{lessonName}
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

        // /units/study/{lessonName}/filename.ext
        if (uri.pathSegments.length == 4 &&
            uri.pathSegments[0] == 'units' &&
            uri.pathSegments[1] == 'study') {
          final lessonName = uri.pathSegments[2];
          final fileName = uri.pathSegments[3];

          return MaterialPageRoute(
            builder: (context) => ViewNotesView(),
            settings: RouteSettings(
              name: settings.name,
              arguments: {'lessonName': lessonName, 'fileName': fileName},
            ),
          );
        }

        return null;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A68AF)),
          useMaterial3: true,
          fontFamily: 'Jost'),
      home: const MyHomePage(title: 'Note Viewer'),
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
