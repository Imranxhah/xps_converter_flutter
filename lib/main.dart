import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

// --------------------------------------------------------------------------
// MOCK CLASSES/ENUMS (Assuming these are in your actual files)
// --------------------------------------------------------------------------
// NOTE: In a real app, these imports would point to the actual files:
// import 'providers/converter_provider.dart';
// import 'providers/theme_provider.dart';
// import 'screens/home_screen.dart';

// Mock Provider classes from the previous solution:
class ConverterProvider with ChangeNotifier {}

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = true; // Mock state
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Screen Content'));
  }
}
// --------------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Ensure you create the instances correctly
        ChangeNotifierProvider(create: (_) => ConverterProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Determine the ThemeMode based on the provider's state
          final themeMode =
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light;

          return MaterialApp(
            title: 'XPS Converter',
            debugShowCheckedModeBanner: false,

            // Light Theme with FlexColorScheme
            theme: FlexThemeData.light(
              scheme: FlexScheme.deepBlue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 7,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                elevatedButtonRadius: 12.0,
                outlinedButtonRadius: 12.0,
                textButtonRadius: 12.0,
                inputDecoratorRadius: 12.0,
                cardRadius: 16.0,
                chipRadius: 12.0,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),

            // Dark Theme with FlexColorScheme
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.deepBlue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
                elevatedButtonRadius: 12.0,
                outlinedButtonRadius: 12.0,
                textButtonRadius: 12.0,
                inputDecoratorRadius: 12.0,
                cardRadius: 16.0,
                chipRadius: 12.0,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),

            // Apply the determined theme mode
            themeMode: themeMode,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
