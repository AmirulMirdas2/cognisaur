import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/halaman_opening.dart';
import 'database/db_helper.dart'; // Import db_helper yang baru dibuat
import 'services/user_prefs.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite ffi for desktop (Linux, macOS, Windows)
  if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await DatabaseHelper.instance.database;

  await UserPreferences.init();

  runApp(const CogniSaurApp());
}

class CogniSaurApp extends StatelessWidget {
  const CogniSaurApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = UserPreferences.isFirstTime();
    bool isLoggedIn = UserPreferences.isLoggedIn();

    Widget initialScreen;
    if (isFirstTime) {
      initialScreen = const Opening1();
    } else if (!isLoggedIn) {
      initialScreen = const LoginScreen();
    } else {
      initialScreen = const MainNavigation();
    }

    return MaterialApp(
      title: 'CogniSaur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'sans-serif'),
      home: initialScreen,
    );
  }
}
