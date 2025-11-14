import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Privacy indicator badge
///
/// Shows users their data is protected with visual indicator.
/// Helps farmers understand their privacy is protected by default.
class PrivacyBadge extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? color;

  const PrivacyBadge({
    super.key,
    required this.message,
    this.icon,
    this.color,
  });

  /// Factory for common privacy messages
  factory PrivacyBadge.encrypted() {
    return const PrivacyBadge(
      message: 'Your data is encrypted',
      icon: Icons.lock_outline,
    );
  }

  factory PrivacyBadge.private() {
    return const PrivacyBadge(
      message: 'Private to you only',
      icon: Icons.shield_outlined,
    );
  }

  factory PrivacyBadge.notShared() {
    return const PrivacyBadge(
      message: 'Not shared with anyone',
      icon: Icons.security_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppTheme.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space12,
        vertical: AppTheme.space8,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.lock_outline,
            size: 16,
            color: badgeColor,
          ),
          const SizedBox(width: AppTheme.space8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Connection status indicator
///
/// Shows connection status with colored dot + text
class ConnectionStatusIndicator extends StatelessWidget {
  final ConnectionStatus status;

  const ConnectionStatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: status.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: status.color.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.space8),
        Text(
          status.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: status.color,
          ),
        ),
      ],
    );
  }
}

/// Connection status enum
enum ConnectionStatus {
  secure,
  offline,
  error;

  String get label {
    switch (this) {
      case ConnectionStatus.secure:
        return 'Connected securely';
      case ConnectionStatus.offline:
        return 'Offline mode';
      case ConnectionStatus.error:
        return 'Connection error';
    }
  }

  Color get color {
    switch (this) {
      case ConnectionStatus.secure:
        return AppTheme.success;
      case ConnectionStatus.offline:
        return AppTheme.warning;
      case ConnectionStatus.error:
        return AppTheme.error;
    }
  }
}
