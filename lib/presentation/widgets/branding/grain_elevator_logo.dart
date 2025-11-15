import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Custom grain elevator logo for HaulPass branding
class GrainElevatorLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showText;
  final bool animated;

  const GrainElevatorLogo({
    super.key,
    this.size = 48,
    this.color,
    this.showText = true,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryBlue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Grain elevator icon
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _GrainElevatorPainter(
              color: effectiveColor,
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'HaulPass',
                style: TextStyle(
                  fontSize: size * 0.5,
                  fontWeight: FontWeight.bold,
                  color: effectiveColor,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Grain Hauling',
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.w400,
                  color: effectiveColor.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Custom painter for grain elevator icon
class _GrainElevatorPainter extends CustomPainter {
  final Color color;

  _GrainElevatorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Main silo (tall cylinder)
    final siloRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(width * 0.25, height * 0.15, width * 0.3, height * 0.7),
      topLeft: Radius.circular(width * 0.15),
      topRight: Radius.circular(width * 0.15),
    );
    canvas.drawRRect(siloRect, paint);

    // Secondary silo (shorter)
    final silo2Rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(width * 0.6, height * 0.3, width * 0.25, height * 0.55),
      topLeft: Radius.circular(width * 0.125),
      topRight: Radius.circular(width * 0.125),
    );
    canvas.drawRRect(silo2Rect, paint..color = color.withOpacity(0.8));

    // Base building
    final baseRect = Rect.fromLTWH(
      width * 0.15,
      height * 0.7,
      width * 0.7,
      height * 0.25,
    );
    canvas.drawRect(baseRect, paint..color = color.withOpacity(0.9));

    // Roof peak on main silo
    final roofPath = Path()
      ..moveTo(width * 0.25, height * 0.15)
      ..lineTo(width * 0.4, height * 0.05)
      ..lineTo(width * 0.55, height * 0.15)
      ..close();
    canvas.drawPath(roofPath, paint..color = color);

    // Windows on base
    final windowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(width * 0.3, height * 0.75, width * 0.12, width * 0.12),
      windowPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(width * 0.48, height * 0.75, width * 0.12, width * 0.12),
      windowPaint,
    );

    // Horizontal lines on silos (to show sections)
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    canvas.drawLine(
      Offset(width * 0.25, height * 0.4),
      Offset(width * 0.55, height * 0.4),
      linePaint,
    );
    canvas.drawLine(
      Offset(width * 0.25, height * 0.55),
      Offset(width * 0.55, height * 0.55),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple grain elevator icon (no text)
class GrainElevatorIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const GrainElevatorIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GrainElevatorLogo(
      size: size,
      color: color,
      showText: false,
    );
  }
}
