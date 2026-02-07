import 'package:flutter/material.dart';
import '../services/analysis_notification_service.dart';
import 'package:go_router/go_router.dart';

/// Top notification bar overlay for showing analysis progress
/// Matches the RevealIt design with black bar, progress, and timer
class AnalysisNotificationOverlay extends StatefulWidget {
  const AnalysisNotificationOverlay({super.key});

  @override
  State<AnalysisNotificationOverlay> createState() => _AnalysisNotificationOverlayState();
}

class _AnalysisNotificationOverlayState extends State<AnalysisNotificationOverlay> {
  final AnalysisNotificationService _service = AnalysisNotificationService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  String _formatTime(int seconds) {
    return '${seconds}s';
  }

  void _onTap() {
    if (_service.isComplete && _service.analysisResult != null) {
      final result = _service.analysisResult!;
      _service.dismiss();
      // Navigate to analysis result screen with correct route
      if (mounted) {
        context.push('/analysis/new', extra: result);
      }
    }
  }

  void _onDismiss() {
    _service.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    if (!_service.shouldShowNotification) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GestureDetector(
            onTap: _service.isComplete ? _onTap : null,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 8, 0),
                    child: Row(
                      children: [
                        // Icon container
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF374151),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.document_scanner_outlined,
                            color: Color(0xFF22C55E),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _service.isComplete ? 'Analysis Complete!' : 'Analyzing Image...',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                _service.statusText,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Timer/percentage
                        Text(
                          _formatTime(_service.elapsedSeconds),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Dropdown arrow
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 18,
                        ),
                        // Close button
                        GestureDetector(
                          onTap: _onDismiss,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.close,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar - full width, starts from left
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: Stack(
                          children: [
                            // Background (gray)
                            Container(
                              width: double.infinity,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            // Progress (green) - starts from left
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: MediaQuery.of(context).size.width * _service.progress * 0.92,
                              color: const Color(0xFF22C55E),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
