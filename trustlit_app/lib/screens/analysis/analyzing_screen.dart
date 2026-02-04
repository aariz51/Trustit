import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Analyzing Screen - Shows loading animation while product is being analyzed
class AnalyzingScreen extends StatefulWidget {
  final String? frontImagePath;
  final String? backImagePath;

  const AnalyzingScreen({
    super.key,
    this.frontImagePath,
    this.backImagePath,
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentStep = 0;
  
  final List<String> _steps = [
    'Reading product label...',
    'Extracting ingredients...',
    'Analyzing safety data...',
    'Generating report...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Simulate analysis steps
    _simulateAnalysis();
  }

  void _simulateAnalysis() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _currentStep = i + 1;
        });
      }
    }

    // Navigate to result after analysis completes
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      // Generate a mock analysis ID - will be replaced with real API response
      context.pushReplacement('/analysis/mock-analysis-123');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated scanning graphic
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ring
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value * 2 * 3.14159,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFDCFCE7),
                                  width: 4,
                                ),
                              ),
                              child: CustomPaint(
                                painter: _ArcPainter(progress: _animation.value),
                              ),
                            ),
                          );
                        },
                      ),
                      // Inner icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.document_scanner_outlined,
                          size: 40,
                          color: Color(0xFF22C55E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                const Text(
                  'Analyzing Product',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 16),

                // Current step
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _currentStep < _steps.length
                        ? _steps[_currentStep]
                        : 'Complete!',
                    key: ValueKey(_currentStep),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // Progress indicator
                Container(
                  width: 200,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (_currentStep + 1) / (_steps.length + 1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for animated arc
class _ArcPainter extends CustomPainter {
  final double progress;

  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -3.14159 / 2;
    const sweepAngle = 3.14159 / 2;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
