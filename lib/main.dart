import 'package:flutter/material.dart';
import 'package:flutter_dynamic_app/providers/Theme_provder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/users_screen.dart';
import 'services/api_service.dart';
import 'providers/api_service_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/api_service_provider.dart';
import 'screens/home_screen.dart';
import 'screens/users_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyAppWithLoading(),
    ),
  );
}

class MyAppWithLoading extends ConsumerStatefulWidget {
  @override
  _MyAppWithLoadingState createState() => _MyAppWithLoadingState();
}

class _MyAppWithLoadingState extends ConsumerState<MyAppWithLoading> {
  bool _isThemeLoaded = false; // Flag to indicate if theme is loaded

  @override
  void initState() {
    super.initState();
    // Load the theme when the app initializes
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    // Attempt to load the theme asynchronously
    await ref.read(themeNotifierProvider.notifier).loadTheme();
    setState(() {
      _isThemeLoaded = true; // Mark the theme as loaded once it's fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isThemeLoaded) {
      // Show a loading indicator while the theme is being loaded
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final theme = ref.watch(themeNotifierProvider);

    // Now reintroduce ProviderScope with overrides to ensure proper injection
    return ProviderScope(
      overrides: [
        apiServiceProvider.overrideWithValue(ApiService()),  // Ensure API service is injected properly
      ],
      child: MaterialApp(
        title: 'Dynamic Flutter App',
        theme: theme ?? ThemeData.light(),  // Provide a fallback light theme if theme is null
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/users': (context) => UsersScreen(),
        },
      ),
    );
  }
}
