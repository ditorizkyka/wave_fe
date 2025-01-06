import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave_fe/view/core/auth/login_page/login_page.dart';
import 'package:wave_fe/view/core/auth/signup/signup_page.dart';
import 'package:wave_fe/view/core/dashboard/course/course_detail/course_detail_page.dart';
import 'package:wave_fe/view/core/dashboard/course/module_detail/module_detail_page.dart';
import 'package:wave_fe/view/core/dashboard/course/course_page.dart';
import 'package:wave_fe/view/core/dashboard/course/quiz/quiz_page.dart';
import 'package:wave_fe/view/core/dashboard/dashboard_page.dart';
import 'package:wave_fe/view/core/profile/profile_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/login",
      name: 'login',
      builder: (context, state) => const LoginPage(),
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginPage(),
      ),
    ),
    GoRoute(
      path: "/signup",
      name: 'signup',
      builder: (context, state) => const SignupPage(),
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignupPage(),
      ),
    ),
    GoRoute(
      path: "/",
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
      routes: [
        GoRoute(
          path: "profile",
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: 'courses',
          name: 'courses',
          builder: (context, state) => const CoursePage(),
          routes: [
            GoRoute(
              path: ":coursePathId",
              name: 'DBCourse',
              builder: (context, state) {
                final coursePathId =
                    state.pathParameters['coursePathId'] ?? "0";
                return CourseDetailPage(
                  coursePathId: coursePathId,
                );
              },
              routes: [
                GoRoute(
                  path: "module/:modulePathId",
                  name: 'module',
                  builder: (context, state) {
                    final coursePathId = Uri.decodeComponent(
                        state.pathParameters['coursePathId'] ?? 'no_course');
                    final modulePathId = Uri.decodeComponent(
                        state.pathParameters['modulePathId'] ?? 'no_module');
                    return ModuleDetailPage(
                      courseId: coursePathId,
                      moduleId: modulePathId,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: "quiz/:questionPathId",
                      name: 'quiz',
                      builder: (context, state) {
                        final coursePathId = Uri.decodeComponent(
                            state.pathParameters['coursePathId'] ??
                                'no_course');
                        final questionPathId = Uri.decodeComponent(
                            state.pathParameters['questionPathId'] ??
                                '0'); // Perbaikan di sini
                        final modulePathId = Uri.decodeComponent(
                            state.pathParameters['modulePathId'] ??
                                'no_module');
                        return QuizPage(
                          coursePathId: coursePathId,
                          modulePathId: modulePathId,
                          questionPathId: questionPathId,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await checkUserLoggedIn();

    if (!isLoggedIn) {
      // Jika belum login, arahkan ke halaman login
      if (state.matchedLocation != '/login' &&
          state.matchedLocation == '/signup') {
        return '/signup';
      } else if (state.matchedLocation == '/login' &&
          state.matchedLocation != '/signup') {
        return '/login';
      } else if (state.matchedLocation != '/login' &&
          state.matchedLocation != '/signup') {
        return '/login';
      }
    } else if (isLoggedIn && state.matchedLocation == '/login') {
      // Jika sudah login, arahkan ke dashboard
      return '/';
    }
    // Tetap di halaman yang diminta
    return null;
  },
  initialLocation: '/login',
  routerNeglect: true,

  // debugLogDiagnostics: true,
);

Future<bool> checkUserLoggedIn() async {
  // Mengakses SharedPreferences untuk mengambil token
  final prefs = await SharedPreferences.getInstance();
  // Mengambil nilai token dari SharedPreferences
  final token = prefs.getString('userToken');

  // Periksa apakah token ada dan tidak kosong
  if (token != null && token.isNotEmpty) {
    return true; // Pengguna sudah login
  } else {
    return false; // Pengguna belum login
  }
}
