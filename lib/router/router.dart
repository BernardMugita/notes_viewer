import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/views/account/account_view.dart';
import 'package:maktaba/views/auth/course/course_view.dart';
import 'package:maktaba/views/auth/login/login_view.dart';
import 'package:maktaba/views/dashboard/dashboard_view.dart';
import 'package:maktaba/views/notes/notes_view.dart';
import 'package:maktaba/views/settings/settings_view.dart';
import 'package:maktaba/views/splash/splash_screen.dart';
import 'package:maktaba/views/study/study_view.dart';
import 'package:maktaba/views/units/units_view.dart';
import 'package:maktaba/views/view_notes/view_notes_view.dart';

final authProvider = AuthProvider();

GoRouter createRouter(
    AuthProvider authProvider,
    TogglesProvider toggleProvider,
    UserProvider userProvider,
    UnitsProvider unitsProvider,
    CoursesProvider coursesProvider,
    LessonsProvider lessonsProvider) {
  return GoRouter(
    initialLocation: authProvider.isAuthenticated ? '/dashboard' : '/login',
    refreshListenable: Listenable.merge([
      AuthProviderNotifier(authProvider),
      TogglesProviderNotifier(toggleProvider),
    ]),
    redirect: (BuildContext context, GoRouterState state) {
      if (authProvider.isLoading || toggleProvider.isLoading) return null;

      if (!authProvider.isAuthenticated) return '/login';
      if (authProvider.isAuthenticated && state.matchedLocation == '/login') {
        return toggleProvider.rememberSelection ? '/dashboard' : '/course';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/course',
        builder: (context, state) => const CourseView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardView(),
      ),
      GoRoute(
        path: '/units',
        builder: (context, state) => const UnitsView(),
      ),
      GoRoute(
        path: '/units/notes',
        builder: (context, state) => const NotesView(),
      ),
      GoRoute(
        path: '/units/notes/:lesson',
        builder: (context, state) {
          final lesson = state.pathParameters['lesson']!;
          return StudyView(lesson: lesson);
        },
      ),
      GoRoute(
        path: '/units/notes/:lesson/:fileName',
        builder: (context, state) {
          final lesson = state.pathParameters['lesson']!;
          final fileName = state.pathParameters['fileName']!;
          return ViewNotesView(lesson: lesson, fileName: fileName);
        },
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => AccountView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsView(),
      )
    ],
  );
}

// Wrapper for AuthProvider to use with GoRouter
class AuthProviderNotifier extends ChangeNotifier {
  final AuthProvider _authProvider;

  AuthProviderNotifier(this._authProvider) {
    _authProvider.addListener(() {
      notifyListeners();
    });
  }

  bool get isAuthenticated => _authProvider.isAuthenticated;
}

class TogglesProviderNotifier extends ChangeNotifier {
  final TogglesProvider _togglesProvider;

  TogglesProviderNotifier(this._togglesProvider) {
    _togglesProvider.addListener(() {
      notifyListeners();
    });
  }

  bool get rememberSelection => _togglesProvider.rememberSelection;
  bool get isLoading => _togglesProvider.isLoading;
}
