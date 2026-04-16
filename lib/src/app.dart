import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/controllers/theme_mode_controller.dart';
import 'presentation/screens/root_screen.dart';

class RickMortyApp extends ConsumerWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFC0FA72),
      onPrimary: Color(0xFF162700),
      primaryContainer: Color(0xFF7BB031),
      onPrimaryContainer: Color(0xFF0D1A00),
      secondary: Color(0xFF5FE2FC),
      onSecondary: Color(0xFF002A31),
      secondaryContainer: Color(0xFF006877),
      onSecondaryContainer: Color(0xFFEAFBFF),
      tertiary: Color(0xFFFFC3E3),
      onTertiary: Color(0xFF471536),
      tertiaryContainer: Color(0xFF8D4F73),
      onTertiaryContainer: Color(0xFFFFD8EE),
      error: Color(0xFFFF7351),
      onError: Color(0xFF450900),
      errorContainer: Color(0xFFB92902),
      onErrorContainer: Color(0xFFFFD2C8),
      surface: Color(0xFF0B0E14),
      onSurface: Color(0xFFF2F3FC),
      onSurfaceVariant: Color(0xFFA9ABB3),
      outline: Color(0xFF73757D),
      outlineVariant: Color(0xFF45484F),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFF9F9FF),
      onInverseSurface: Color(0xFF52555C),
      inversePrimary: Color(0xFF426A00),
      surfaceTint: Color(0xFFC0FA72),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick and Morty Characters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1BC7B1)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: darkScheme.surface,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: darkScheme.surface.withValues(alpha: 0.84),
          foregroundColor: darkScheme.onSurface,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: darkScheme.primary.withValues(alpha: 0.18),
          backgroundColor: const Color(0xFF10131A).withValues(alpha: 0.9),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF22262E),
          selectedColor: darkScheme.primary.withValues(alpha: 0.2),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          side: BorderSide(
            color: darkScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
      themeMode: ref.watch(themeModeProvider),
      home: const RootScreen(),
    );
  }
}
