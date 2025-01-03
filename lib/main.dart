import 'package:flutter/material.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/views/auth/course/course_view.dart';
import 'package:note_viewer/views/auth/login/login_view.dart';
import 'package:note_viewer/views/dashboard/desktop_dashboard.dart';
import 'package:note_viewer/views/dashboard/mobile_dashboard.dart';
import 'package:note_viewer/views/dashboard/tablet_dashboard.dart';
import 'package:note_viewer/views/units/units_view.dart';
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
      initialRoute: '/',
      // Provider.of<AuthProvider>(context, listen: false).isAuthenticated
      //     ? '/'
      //     : '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/course': (context) => const CourseView(),
        '/units': (context) => const UnitsView(),
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
