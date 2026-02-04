import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/paywall/paywall_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/confirm/confirm_screen.dart';
import '../screens/analysis/analysis_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/main/main_shell.dart';

/// TrustLit App Router Configuration
/// Defines all routes and navigation logic
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Paywall Screen
      GoRoute(
        path: '/paywall',
        name: 'paywall',
        builder: (context, state) => const PaywallScreen(),
      ),

      // Main Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home Screen
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          // History Screen
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryScreen(),
          ),

          // Chat Screen
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),

          // Profile Screen
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Camera Screen (Full screen, no bottom nav)
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) => const CameraScreen(),
      ),

      // Confirm Screen (Full screen, no bottom nav)
      GoRoute(
        path: '/confirm',
        name: 'confirm',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null ||
              extra['frontImagePath'] == null ||
              extra['backImagePath'] == null) {
            throw ArgumentError(
                'ConfirmScreen requires frontImagePath and backImagePath in route extras');
          }
          return ConfirmScreen(
            frontImagePath: extra['frontImagePath'] as String,
            backImagePath: extra['backImagePath'] as String,
          );
        },
      ),

      // Analysis Screen (Full screen, no bottom nav)
      GoRoute(
        path: '/analysis',
        name: 'analysis',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null || extra['analysisId'] == null) {
            throw ArgumentError(
                'AnalysisScreen requires analysisId in route extras');
          }
          return AnalysisScreen(
            analysisId: extra['analysisId'] as String,
          );
        },
      ),
    ],
  );
}
