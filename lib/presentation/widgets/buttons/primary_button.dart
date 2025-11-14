import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Primary action button with glow effect
///
/// Follows HaulPass design system:
/// - 56dp height for easy farmer touch
/// - Gradient background (primary → primaryDark)
/// - Soft glow shadow effect
/// - Loading state with spinner
/// - Optional leading icon
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _isPressed ? 0.96 : 1.0,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isDisabled ? 0.6 : 1.0,
          child: Container(
            height: 56,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              gradient: isDisabled
                  ? null
                  : const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: isDisabled ? AppTheme.onSurfaceVariant : null,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: isDisabled ? null : AppTheme.primaryGlow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null && !widget.isLoading) ...[
                        Icon(widget.icon, color: Colors.white, size: 24),
                        const SizedBox(width: AppTheme.space8),
                      ],
                      if (widget.isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        Text(
                          widget.text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
