import 'package:flutter/material.dart';
import 'presentation/main_navigation_shell.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JelajahTataSuryaApp());
}

/// Root Application Widget for "Jelajah Tata Surya"
class JelajahTataSuryaApp extends StatelessWidget {
  const JelajahTataSuryaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelajah Tata Surya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationShell(),
    );
  }
}
