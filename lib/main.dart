import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_config.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/elevator/elevator_screen.dart';
import 'presentation/screens/timer/timer_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';

/// Main app widget with Riverpod provider scope and routing
class HaulPassApp extends ConsumerWidget {
  const HaulPassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);
    
    return MaterialApp.router(
      title: 'HaulPass',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        // Add localization delegates here when needed
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('fr', 'CA'), // French (Canadian)
      ],
    );
  }

  /// Create GoRouter configuration
  GoRouter _createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        // Check authentication status
        final isAuthenticated = ref.read(isAuthenticatedProvider);
        final authState = ref.read(authNotifierProvider);
        
        final currentLocation = state.uri.path;
        final isAuthRoute = currentLocation.startsWith('/auth');
        
        // Redirect logic
        if (!isAuthenticated && !isAuthRoute) {
          return '/auth';
        }
        
        if (isAuthenticated && isAuthRoute) {
          return '/';
        }
        
        return null; // No redirect needed
      },
      routes: [
        // Authentication route
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        
        // Main app routes
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/elevators',
          builder: (context, state) => const ElevatorScreen(),
        ),
        GoRoute(
          path: '/timer',
          builder: (context, state) => const TimerScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
      
      // Error handling
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase with placeholder values
    // These will be replaced when user provides actual credentials
    await initializeSupabase(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder-key',
    );
  } catch (e) {
    print('Failed to initialize Supabase: $e');
    // Continue anyway - user will need to provide credentials
  }
  
  runApp(
    const ProviderScope(
      child: HaulPassApp(),
    ),
  );
}
