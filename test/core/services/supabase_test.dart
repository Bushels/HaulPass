import 'package:flutter_test/flutter_test.dart';
import 'package:haulpass/core/services/environment_service.dart';
import 'package:haulpass/core/services/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Supabase Configuration Tests', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize environment service
      await EnvironmentService.instance.initialize();
    });

    test('Environment service loads Supabase credentials', () {
      final env = EnvironmentService.instance;

      expect(env.supabaseUrl, isNotEmpty);
      expect(env.supabaseAnonKey, isNotEmpty);
      expect(env.supabaseUrl, contains('supabase.co'));
    });

    test('Supabase URL is correctly formatted', () {
      final url = EnvironmentService.instance.supabaseUrl;

      expect(url, startsWith('https://'));
      expect(url, contains('.supabase.co'));
      expect(url, equals('https://nwismkrgztbttlndylmu.supabase.co'));
    });

    test('Supabase anon key is valid format', () {
      final key = EnvironmentService.instance.supabaseAnonKey;

      // JWT tokens have 3 parts separated by dots
      expect(key.split('.').length, equals(3));
      expect(key, isNotEmpty);
    });

    test('Can initialize Supabase client', () async {
      final env = EnvironmentService.instance;

      // This should not throw an error
      await initializeSupabase(
        url: env.supabaseUrl,
        anonKey: env.supabaseAnonKey,
      );

      // Verify client is initialized
      expect(Supabase.instance.client, isNotNull);
      expect(Supabase.instance.client.auth, isNotNull);
    });

    test('Supabase auth client is available', () {
      final auth = Supabase.instance.client.auth;

      expect(auth, isNotNull);
      // Initially, user should be null (not logged in)
      expect(auth.currentUser, isNull);
    });

    test('Supabase database client is available', () {
      final db = Supabase.instance.client;

      expect(db, isNotNull);
      expect(db.from, isNotNull);
    });
  });

  group('Environment Validation', () {
    test('Required environment variables are configured', () {
      final env = EnvironmentService.instance;

      expect(env.isConfigured, isTrue);
    });

    test('Environment info shows correct configuration', () {
      final info = EnvironmentService.instance.getEnvironmentInfo();

      expect(info['SUPABASE_URL'], equals('✓ Configured'));
      expect(info['SUPABASE_ANON_KEY'], equals('✓ Configured'));
      expect(info['initialized'], equals('true'));
      expect(info['isConfigured'], equals('true'));
    });
  });
}
