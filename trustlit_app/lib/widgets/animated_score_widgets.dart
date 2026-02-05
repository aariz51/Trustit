import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated Circular Score Widget
/// Displays a score (0-100) with animation from 0 to target value
/// Color changes based on score: Red (<40), Yellow (40-69), Green (70+)
class AnimatedCircularScore extends StatefulWidget {
  final int score;
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final Duration animationDuration;

  const AnimatedCircularScore({
    super.key,
    required this.score,
    this.size = 60,
    this.strokeWidth = 6,
    this.showLabel = false,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedCircularScore> createState() => _AnimatedCircularScoreState();
}

class _AnimatedCircularScoreState extends State<AnimatedCircularScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after a small delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedCircularScore oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  Color _getScoreColor(double score) {
    if (score < 40) {
      return const Color(0xFFEF4444); // Red
    } else if (score < 70) {
      return const Color(0xFFF59E0B); // Yellow/Orange
    } else {
      return const Color(0xFF22C55E); // Green
    }
  }

  String _getScoreLabel(double score) {
    if (score < 25) return 'Bad';
    if (score < 40) return 'Poor';
    if (score < 55) return 'Medium';
    if (score < 70) return 'Average';
    if (score < 85) return 'Good';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = _animation.value;
        final color = _getScoreColor(currentScore);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _CircleProgressPainter(
                      progress: currentScore / 100,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.2),
                      strokeWidth: widget.strokeWidth,
                    ),
                  ),
                  // Score number
                  Text(
                    currentScore.round().toString(),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: widget.size * 0.35,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showLabel) ...[
              const SizedBox(height: 4),
              Text(
                _getScoreLabel(currentScore),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Animated Progress Bar for Safety/Efficacy/Transparency scores
class AnimatedScoreBar extends StatefulWidget {
  final String label;
  final int score;
  final Duration animationDuration;

  const AnimatedScoreBar({
    super.key,
    required this.label,
    required this.score,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedScoreBar> createState() => _AnimatedScoreBarState();
}

class _AnimatedScoreBarState extends State<AnimatedScoreBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score < 40) {
      return const Color(0xFFEF4444); // Red
    } else if (score < 70) {
      return const Color(0xFFF59E0B); // Yellow/Orange
    } else {
      return const Color(0xFF22C55E); // Green
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = _animation.value;
        final color = _getScoreColor(currentScore);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Labels row - label at start, score at end
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  Text(
                    currentScore.round().toString(),
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Progress bar - full width
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: currentScore / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
