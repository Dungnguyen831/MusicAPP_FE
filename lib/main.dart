import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/services/audio_player_handler.dart'; // Import the new audio service handler
import 'features/home/presentation/home_screen.dart'; // Import HomeScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for FlutterNativeSplash.preserve and audio_service
  await initAudioService(); // Initialize audio_service
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stitch Music',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(), // Use HomeScreen as the home widget
    );
  }
}
