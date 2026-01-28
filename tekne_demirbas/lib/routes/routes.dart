import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tekne_demirbas/features/authentication/presentation/screens/register_screen.dart';
import 'package:tekne_demirbas/features/authentication/presentation/screens/sign_in_screen.dart';
import 'package:tekne_demirbas/features/authentication/presentation/screens/splash_screen.dart';
import 'package:tekne_demirbas/features/room_management/presentation/screens/room_selection_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/main_screen.dart';
import 'package:tekne_demirbas/routes/go_router_refresh_stream.dart';

part 'routes.g.dart';

enum AppRoutes { splash, roomSelection, main, signIn, register }

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

  @riverpod
GoRouter goRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (ctx, state) {
      final currentPath = state.uri.toString();
      
      // Splash screen'den redirect yapma
      if (currentPath == '/splash') {
        return null;
      }

      final isLoggedIn = firebaseAuth.currentUser != null;
      final isEmailVerified = firebaseAuth.currentUser?.emailVerified ?? false;

      // Email doğrulanmamış kullanıcı giriş yapamaz
      if (isLoggedIn && !isEmailVerified && 
          (currentPath == '/main' || currentPath == '/roomSelection')) {
        return '/signIn'; // Email doğrulama mesajı gösterilecek
      }

      if (isLoggedIn && isEmailVerified &&
          (currentPath == '/signIn' || currentPath == '/register')) {
        return '/roomSelection';
      } else if (!isLoggedIn && 
          (currentPath.startsWith('/main') || currentPath.startsWith('/roomSelection'))) {
        return '/signIn';
      } else {
        return null;
      }
    },
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash.name,
        builder: (cxt, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/roomSelection',
        name: AppRoutes.roomSelection.name,
        builder: (cxt, state) => const RoomSelectionScreen(),
      ),
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
