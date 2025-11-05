import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/environment_service.dart';
import 'core/services/supabase_config.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/auth_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/home/enhanced_home_screen.dart';
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
          builder: (context, state) => const EnhancedHomeScreen(),
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

/// Main entry point with secure environment configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize environment service for secure configuration loading
    await EnvironmentService.instance.validateAll();
    
    // Load Supabase configuration from environment variables
    final env = EnvironmentService.instance;
    
    // Get configuration from environment service
    final supabaseUrl = env.supabaseUrl;
    final supabaseAnonKey = env.supabaseAnonKey;
    
    // Validate that we have valid configuration (not placeholder values)
    if (supabaseUrl == 'https://your-project.supabase.co' || 
        supabaseAnonKey == 'your-anon-key-here') {
      throw EnvironmentException(
        'Supabase configuration not properly set. Please update your environment variables '
        'with actual Supabase URL and anonymous key before running the app.'
      );
    }
    
    // Initialize Supabase with secure environment configuration
    await initializeSupabase(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    
    if (kDebugMode) {
      debugPrint('✅ Supabase initialized successfully with environment configuration');
      debugPrint('📱 Platform: ${kIsWeb ? "Web" : "Mobile"}');
      debugPrint('🌍 Environment: ${EnvironmentService.instance.buildTimeConfig}');
    }
    
  } catch (e) {
    // Handle configuration errors gracefully
    if (e is EnvironmentException) {
      debugPrint('❌ Environment Configuration Error: $e');
      
      // Show user-friendly error message for configuration issues
      if (kDebugMode) {
        debugPrint('Environment variables needed:');
        debugPrint('- SUPABASE_URL: Your Supabase project URL');
        debugPrint('- SUPABASE_ANON_KEY: Your Supabase anonymous key');
        debugPrint('- GOOGLE_MAPS_API_KEY: Your Google Maps API key');
        debugPrint('For web deployment, add these as meta tags or window variables');
      }
    } else {
      debugPrint('❌ Initialization Error: $e');
    }
    
    // For development, continue with app initialization even if Supabase fails
    // In production, you might want to exit or show a configuration screen
    if (!kDebugMode) {
      // In production, show error screen instead of continuing
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Configuration Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your environment configuration.\n'
                  'Contact support if the problem persists.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ));
      return;
    }
  }
  
  runApp(
    const ProviderScope(
      child: HaulPassApp(),
    ),
  );
}