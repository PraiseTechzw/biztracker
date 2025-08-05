import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/database_service.dart';
import 'utils/glassmorphism_theme.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize database
  await DatabaseService.initialize();

  runApp(const BizTrackerApp());
}

class BizTrackerApp extends StatelessWidget {
  const BizTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BizTracker',
      debugShowCheckedModeBanner: false,
      theme: GlassmorphismTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}
