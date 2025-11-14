import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/buttons/primary_button.dart';

/// Main authentication landing screen
/// Routes to either sign in or sign up
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Icon(
                    Icons.local_shipping_rounded,
                    size: 120,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 32),

                  // App name
                  Text(
                    'HaulPass',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    'Reduce Wait Times.\nTrack Every Load.\nHaul Smarter.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Features
                  _buildFeatureRow(
                    context,
                    Icons.timer_outlined,
                    'Real-time Queue Intelligence',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureRow(
                    context,
                    Icons.analytics_outlined,
                    'Comprehensive Tracking',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureRow(
                    context,
                    Icons.speed_outlined,
                    'Efficiency Insights',
                  ),
                  const SizedBox(height: 48),

                  // Sign up button
                  PrimaryButton(
                    text: 'Get Started',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      context.push('/auth/signup');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sign in button
                  OutlinedButton(
                    onPressed: () {
                      context.push('/auth/signin');
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Terms
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
