import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tekne_demirbas/features/authentication/presentation/screens/register_screen.dart';
import 'package:tekne_demirbas/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/main_screen.dart';
import 'package:tekne_demirbas/routes/go_router_refresh_stream.dart';

part 'routes.g.dart';

enum AppRoutes { main, signIn, register }

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

@riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/main',
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;

      if (isLoggedIn &&
          (state.uri.toString() == '/signIn' ||
              state.uri.toString() == '/register')) {
        return '/main';
      } else if (!isLoggedIn && state.uri.toString().startsWith('/main')) {
        return '/signIn';
      } else {
        return null;
      }
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/main',
        name: AppRoutes.main.name,
        builder: (cxt, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/signIn',
        name: AppRoutes.signIn.name,
        builder: (cxt, state) => SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (cxt, state) => RegisterScreen(),
      ),
    ],
  );
}
