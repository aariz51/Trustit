import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'config/app_router.dart';
import 'providers/subscription_provider.dart';
import 'providers/scan_history_provider.dart';
import 'providers/analysis_provider.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox('subscription');
  await Hive.openBox('scanHistory');
  await Hive.openBox('settings');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize API service
  ApiService().initialize();

  runApp(const TrustLitApp());
}

class TrustLitApp extends StatelessWidget {
  const TrustLitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = SubscriptionProvider();
            provider.initialize();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = ScanHistoryProvider();
            provider.loadHistory();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AnalysisProvider();
            provider.initialize();
            return provider;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'TrustLit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
