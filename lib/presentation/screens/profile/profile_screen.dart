import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_models.dart';
import '../../providers/auth_provider.dart';

/// User profile and settings screen
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _truckNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _displayNameController.text = user.displayName ?? '';
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _companyController.text = user.company ?? '';
      _truckNumberController.text = user.truckNumber ?? '';
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _truckNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final userSettings = ref.watch(userSettingsProvider);
    final isPremium = user?.hasPremiumAccess ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: _showSettingsMenu,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Refresh profile data
                await ref.read(authNotifierProvider.notifier).signOut();
                await ref.read(authNotifierProvider.notifier).signIn(
                  user.email,
                  'dummy', // This would require re-authentication
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    _buildProfileCard(user),
                    const SizedBox(height: 16),
                    _buildSubscriptionCard(isPremium, user.subscription),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 16),
                    _buildSettingsSection(userSettings),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader(UserProfile user) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Text(
                user.displayNameWithFallback.substring(0, 1).toUpperCase(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayNameWithFallback,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user.hasPremiumAccess
                          ? Colors.green.withOpacity(0.2)
                          : Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.hasPremiumAccess ? 'Premium Member' : 'Free Account',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: user.hasPremiumAccess
                            ? Colors.green
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfile user) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Profile Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _truckNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Truck Number',
                      prefixIcon: Icon(Icons.local_shipping),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _updateProfile,
                      child: const Text('Update Profile'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(bool isPremium, UserSubscription? subscription) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              isPremium ? Icons.verified : Icons.star_border,
              color: isPremium
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            title: Text(
              isPremium ? 'Premium Account' : 'Free Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: isPremium && subscription != null
                ? Text(
                    'Expires: ${subscription.endDate.toString().split(' ')[0]}',
                  )
                : const Text('Upgrade to unlock premium features'),
            trailing: isPremium
                ? const Icon(Icons.check_circle, color: Colors.green)
                : FilledButton.tonal(
                    onPressed: _showSubscriptionOptions,
                    child: const Text('Upgrade'),
                  ),
          ),
          if (isPremium && subscription != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: subscription.features.take(3).map((feature) {
                  return ListTile(
                    leading: const Icon(Icons.check, color: Colors.green),
                    title: Text(_formatFeatureName(feature)),
                    contentPadding: const EdgeInsets.only(left: 72),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer History'),
            subtitle: const Text('View your completed timers'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => context.push('/timer'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            subtitle: const Text('View hauling statistics'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showAnalytics,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Location History'),
            subtitle: const Text('View your movement history'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showLocationHistory,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help or contact support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showHelp,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(UserSettings? userSettings) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: userSettings?.enablePushNotifications ?? true,
            onChanged: (value) {
              // Update notification settings
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive email notifications'),
            value: userSettings?.enableEmailNotifications ?? true,
            onChanged: (value) {
              // Update notification settings
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Allow location tracking'),
            value: userSettings?.enableLocationServices ?? true,
            onChanged: (value) {
              // Update location settings
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(userSettings?.theme ?? 'System'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showThemeSelector,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(userSettings?.language == 'en' ? 'English' : 'French'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showLanguageSelector,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View our privacy policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: _showPrivacyPolicy,
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Terms of Service'),
            subtitle: const Text('View our terms of service'),
            trailing: const Icon(Icons.open_in_new),
            onTap: _showTermsOfService,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: _showSignOutDialog,
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final updatedProfile = user.copyWith(
      displayName: _displayNameController.text.trim().isEmpty
          ? null
          : _displayNameController.text.trim(),
      firstName: _firstNameController.text.trim().isEmpty
          ? null
          : _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim().isEmpty
          ? null
          : _lastNameController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      company: _companyController.text.trim().isEmpty
          ? null
          : _companyController.text.trim(),
      truckNumber: _truckNumberController.text.trim().isEmpty
          ? null
          : _truckNumberController.text.trim(),
    );

    ref.read(authNotifierProvider.notifier).updateProfile(updatedProfile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
      ),
    );
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh Data'),
              onTap: () {
                Navigator.of(context).pop();
                // Refresh all data
              },
            ),
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Export Data'),
              onTap: () {
                Navigator.of(context).pop();
                // Export user data
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Your Plan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // TODO: Implement subscription UI
            const Text('Subscription options coming soon'),
          ],
        ),
      ),
    );
  }

  void _showAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analytics'),
        content: const Text('Analytics dashboard coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLocationHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location History'),
        content: const Text('Location history view coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text('Help center coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: 'system', // Current theme setting
              onChanged: (value) {
                // Update theme setting
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: 'system',
              onChanged: (value) {
                // Update theme setting
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('System'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) {
                // Update theme setting
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'en', // Current language setting
              onChanged: (value) {
                // Update language setting
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Français'),
              value: 'fr',
              groupValue: 'en',
              onChanged: (value) {
                // Update language setting
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    // Open privacy policy in web browser or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy coming soon'),
      ),
    );
  }

  void _showTermsOfService() {
    // Open terms of service in web browser or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service coming soon'),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authNotifierProvider.notifier).signOut();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String _formatFeatureName(String feature) {
    // Convert snake_case to Title Case
    return feature
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
