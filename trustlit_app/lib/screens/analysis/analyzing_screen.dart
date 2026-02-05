import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../models/scan_history_model.dart';
import '../../models/analysis_result_model.dart';

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
  String? _errorMessage;
  bool _isAnalyzing = true;
  
  final List<String> _steps = [
    'Reading product label...',
    'Extracting ingredients...',
    'Analyzing safety data...',
    'Generating report...',
  ];

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start real analysis
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    if (widget.frontImagePath == null || widget.backImagePath == null) {
      setState(() {
        _errorMessage = 'No images provided for analysis';
        _isAnalyzing = false;
      });
      return;
    }

    // Animate through steps while API is called
    _animateSteps();

    try {
      // Initialize API if not already done
      _apiService.initialize();

      // Call the backend API
      debugPrint('Starting analysis with images:');
      debugPrint('Front: ${widget.frontImagePath}');
      debugPrint('Back: ${widget.backImagePath}');

      final response = await _apiService.analyzeProduct(
        frontImagePath: widget.frontImagePath!,
        backImagePath: widget.backImagePath!,
        productType: 'food',
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        // Parse response data
        final data = response.data!;
        final analysisId = response.analysisId ?? DateTime.now().millisecondsSinceEpoch.toString();
        
        // Extract scores with defaults
        final overallScore = (data['overallScore'] as num?)?.toInt() ?? 50;
        final productName = data['productName'] as String? ?? 'Unknown Product';
        final category = data['category'] as String? ?? 'Product';

        // Create scan history entry with full analysis data
        final scanEntry = ScanHistoryModel(
          id: analysisId,
          productName: productName,
          category: category,
          overallScore: overallScore,
          ratingLabel: ScanHistoryModel.getRatingFromScore(overallScore),
          thumbnailPath: widget.frontImagePath,
          fullAnalysis: AnalysisResultModel.fromJson(data),
          scannedAt: DateTime.now(),
        );

        // Save to local storage
        await _storageService.addScanHistory(scanEntry);
        debugPrint('Scan saved to history: $productName (Score: $overallScore)');

        // Navigate to result screen with the data including image path
        if (mounted) {
          // Add image path to the data for display
          final navigationData = Map<String, dynamic>.from(data);
          navigationData['imagePath'] = widget.frontImagePath;
          
          context.pushReplacement(
            '/analysis/$analysisId',
            extra: navigationData,
          );
        }
      } else {
        // API call failed
        setState(() {
          _errorMessage = response.error ?? 'Analysis failed';
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      debugPrint('Analysis error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Error analyzing product: $e';
          _isAnalyzing = false;
        });
      }
    }
  }

  void _animateSteps() async {
    for (int i = 0; i < _steps.length && _isAnalyzing; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted && _isAnalyzing) {
        setState(() {
          _currentStep = i + 1;
        });
      }
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
            child: _errorMessage != null
                ? _buildErrorView()
                : _buildLoadingView(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
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
                : 'Almost done...',
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
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 300),
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
    );
  }

  Widget _buildErrorView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFFFEE2E2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 48,
            color: Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Analysis Failed',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage ?? 'Unknown error',
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isAnalyzing = true;
                  _currentStep = 0;
                });
                _startAnalysis();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Retry'),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ],
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
