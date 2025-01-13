import 'package:flutter/material.dart';
import 'package:note_viewer/providers/auth_provider.dart';
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

  // Load initial state for providers
  await authProvider.checkLogin();
  await toggleProvider.loadRememberSelection();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => toggleProvider),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => UnitsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MyApp(
        authProvider: authProvider,
        toggleProvider: toggleProvider,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;
  final TogglesProvider toggleProvider;

  const MyApp({
    super.key,
    required this.authProvider,
    required this.toggleProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (authProvider.isLoading || toggleProvider.isLoading) {
      return MaterialApp(
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    }

    final router =
        createRouter(authProvider, toggleProvider); // This will now work

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
