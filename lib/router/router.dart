import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/views/account/account_view.dart';
import 'package:maktaba/views/admin/maktaba_admin/maktaba_admin.dart';
import 'package:maktaba/views/auth/course/course_view.dart';
import 'package:maktaba/views/auth/login/login_view.dart';
import 'package:maktaba/views/auth/reset_password/change_password/change_password_view.dart';
import 'package:maktaba/views/dashboard/dashboard_view.dart';
import 'package:maktaba/views/landing_page/landing_page.dart';
import 'package:maktaba/views/notes/notes_view.dart';
import 'package:maktaba/views/settings/settings_view.dart';
import 'package:maktaba/views/splash/splash_screen.dart';
import 'package:maktaba/views/study/study_view.dart';
import 'package:maktaba/views/units/units_view.dart';
import 'package:maktaba/views/admin/lessons_manager/lessons_manager.dart';
import 'package:maktaba/views/admin/material_manager/material_manager.dart';
import 'package:maktaba/views/admin/units_manager/units_manager.dart';
import 'package:maktaba/views/view_notes/view_notes_view.dart';

final authProvider = AuthProvider();

GoRouter createRouter(
  AuthProvider authProvider,
  TogglesProvider toggleProvider,
  UserProvider userProvider,
  UnitsProvider unitsProvider,
  CoursesProvider coursesProvider,
  LessonsProvider lessonsProvider,
) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([
      AuthProviderNotifier(authProvider),
      TogglesProviderNotifier(toggleProvider),
    ]),
    redirect: (BuildContext context, GoRouterState state) {
      if (authProvider.isLoading || toggleProvider.isLoading) return null;

      final isAuthenticated = authProvider.isAuthenticated;
      final isOnLandingPage = state.matchedLocation == '/';
      final isOnLoginPage = state.matchedLocation == '/login';
      final isOnResetPassword = state.matchedLocation == '/reset_password';

      if (isAuthenticated) {
        // Redirect away from login page only (allow landing page access)
        if (isOnLoginPage) {
          return toggleProvider.rememberSelection ? '/dashboard' : '/course';
        }
        return null; // Allow access to all routes including landing page
      }

      if (!isAuthenticated) {
        if (isOnLandingPage || isOnLoginPage || isOnResetPassword) {
          return null; // Allow access to public pages
        }
        return '/'; // Redirect to landing page for protected routes
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPageView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/reset_password',
        builder: (context, state) => const ChangePasswordView(),
      ),
      GoRoute(
        path: '/course',
        builder: (context, state) => const CourseView(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => AccountView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => DashboardView(),
      ),
      GoRoute(
        path: '/maktaba_admin',
        builder: (context, state) => MaktabaAdminView(),
        routes: [
          GoRoute(
            path: 'units_manager/:courseId',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              return UnitsManagerView(courseId: courseId);
            },
            routes: [
              GoRoute(
                path: 'lessons_manager/:unitId',
                builder: (context, state) {
                  final unitId = state.pathParameters['unitId']!;
                  return LessonsManagerView(unitId: unitId);
                },
                routes: [
                  GoRoute(
                    path: 'material_manager/:lessonId',
                    builder: (context, state) {
                      final lessonId = state.pathParameters['lessonId']!;
                      return MaterialManagerView(lessonId: lessonId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/units',
        builder: (context, state) => const UnitsView(),
        routes: [
          GoRoute(
              path: 'notes',
              builder: (context, state) => const NotesView(),
              routes: [
                GoRoute(
                  path: ':lesson',
                  builder: (context, state) {
                    final lesson = state.pathParameters['lesson']!;
                    return StudyView(lesson: lesson);
                  },
                ),
                GoRoute(
                  path: ':lesson/:fileName',
                  builder: (context, state) {
                    final lesson = state.pathParameters['lesson']!;
                    final fileName = state.pathParameters['fileName']!;
                    return ViewNotesView(lesson: lesson, fileName: fileName);
                  },
                ),
              ]),
        ],
      ),
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
