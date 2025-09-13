import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/foods_screen.dart';
import 'screens/favorites_screen.dart';
import 'config/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoList',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/foods': (context) => const FoodsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
