import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/privacy/privacy_badge.dart';
import '../../widgets/branding/grain_elevator_logo.dart';
import '../../../core/theme/app_colors.dart';

/// Sign in screen for returning users
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Icon
                    const Center(
                      child: GrainElevatorIcon(
                        size: 80,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue to HaulPass',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Remember me & Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to forgot password
                            context.push('/auth/forgot-password');
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Privacy indicator
                    const Center(
                      child: PrivacyBadge(
                        message: 'Secure connection',
                        icon: Icons.lock_outline,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign in button
                    PrimaryButton(
                      text: 'Sign In',
                      isLoading: _isLoading,
                      onPressed: _signIn,
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sign up link
                    OutlinedButton(
                      onPressed: () {
                        context.push('/auth/signup');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Create New Account'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Terms and Privacy
                    Text.rich(
                      TextSpan(
                        text: 'By signing in, you agree to our ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    print('👆 Sign in button pressed');
    if (!(_formKey.currentState?.validate() ?? false)) {
      print('❌ Form validation failed');
      return;
    }

    print('✅ Form validation passed');
    setState(() {
      _isLoading = true;
    });

    try {
      print('📞 Calling auth provider signIn method...');
      // Sign in via auth provider
      await ref.read(authNotifierProvider.notifier).signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
      print('✅ SignIn method completed');

      // Small delay to allow Riverpod state to propagate
      // The auth provider already has delays, but this ensures we read the updated state
      await Future.delayed(const Duration(milliseconds: 50));

      // Check for errors
      final authState = ref.read(authNotifierProvider);
      print('🔍 Auth state after signIn: isAuthenticated=${authState.isAuthenticated}, user=${authState.user?.email}, error=${authState.error?.code}');

      if (authState.error != null) {
        print('❌ Auth error detected: ${authState.error!.message}');
        throw Exception(authState.error!.message);
      }

      // Verify we're actually authenticated before navigating
      if (!authState.isAuthenticated) {
        print('⚠️ Auth state not updated immediately, waiting...');
        // Wait a bit more and check again
        await Future.delayed(const Duration(milliseconds: 150));
        final recheckState = ref.read(authNotifierProvider);
        print('🔍 Re-check auth state: isAuthenticated=${recheckState.isAuthenticated}, user=${recheckState.user?.email}');

        if (!recheckState.isAuthenticated) {
          print('❌ Sign in completed but user not authenticated after waiting!');
          throw Exception('Authentication state not updated. Please try again.');
        }
      }

      // Verify session exists in Supabase
      final session = Supabase.instance.client.auth.currentSession;
      print('🔍 Supabase session check: ${session != null ? "present" : "null"}');

      if (session == null) {
        print('❌ No Supabase session found!');
        throw Exception('Session not found. Please try again.');
      }

      if (mounted) {
        print('✅ All checks passed - showing success and navigating...');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home screen
        print('🚀 Navigating to home...');
        context.go('/');
        print('✅ Navigation call completed');
      }
    } catch (e) {
      print('❌ Sign in failed with error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
