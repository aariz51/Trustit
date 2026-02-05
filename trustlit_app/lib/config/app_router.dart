import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/paywall/paywall_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/camera/camera_screen.dart';
import '../screens/confirm/confirm_screen.dart';
import '../screens/analysis/analysis_result_screen.dart';
import '../screens/analysis/analyzing_screen.dart';
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

      // Onboarding Screen
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
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
          return ConfirmScreen(
            frontImagePath: extra?['front'] as String?,
            backImagePath: extra?['back'] as String?,
          );
        },
      ),

      // Analyzing Screen (Full screen, loading animation)
      GoRoute(
        path: '/analyzing',
        name: 'analyzing',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AnalyzingScreen(
            frontImagePath: extra?['front'] as String?,
            backImagePath: extra?['back'] as String?,
          );
        },
      ),

      // Analysis Result Screen (Full screen, no bottom nav)
      GoRoute(
        path: '/analysis/:id',
        name: 'analysis',
        builder: (context, state) {
          final analysisId = state.pathParameters['id'];
          final analysisData = state.extra as Map<String, dynamic>?;
          return AnalysisResultScreen(
            analysisId: analysisId,
            analysisData: analysisData,
          );
        },
      ),
    ],
  );
}
