// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/services/news_provider_api.dart';
import 'package:news_app/services/connectivity_service.dart';
import 'package:news_app/services/bookmarks_provider.dart';
import 'package:news_app/services/search_provider.dart';
import 'package:news_app/services/theme_provider.dart';
import 'package:news_app/services/db/database_service.dart';
import 'package:news_app/screens/splash_screen.dart';
import 'package:news_app/screens/home/widgets/no_internet_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Warm up the SQLite database
  await DatabaseService().database;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProviderApi()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => BookmarksProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConnectivityService, ThemeProvider>(
      builder: (context, connectivity, themeProvider, _) {
        return GetMaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: connectivity.hasInternet
              ? const SplashScreen()
              : NoInternetScreen(onRetry: connectivity.retryConnection),
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                if (!connectivity.hasInternet)
                  NoInternetScreen(onRetry: connectivity.retryConnection),
              ],
            );
          },
        );
      },
    );
  }
}

class AppTheme {
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color deepPurple = Color(0xFF3D35B5);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E2E);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F5FF),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.light).textTheme,
        ),
        cardTheme: CardThemeData(
          color: cardLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D1A),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        cardTheme: CardThemeData(
          color: cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
}