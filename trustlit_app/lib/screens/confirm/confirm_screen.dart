import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/analysis_notification_service.dart';

/// Confirm Screen - Matches designs 20-22.png
/// Shows front and back images side by side with Retake and Start Analysis buttons
class ConfirmScreen extends StatefulWidget {
  final String? frontImagePath;
  final String? backImagePath;

  const ConfirmScreen({
    super.key,
    this.frontImagePath,
    this.backImagePath,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  static const _consentKey = 'ai_data_consent_given';

  /// Show consent dialog before first analysis
  Future<void> _onStartAnalysis() async {
    final prefs = await SharedPreferences.getInstance();
    final consentGiven = prefs.getBool(_consentKey) ?? false;

    if (!consentGiven) {
      // Show consent dialog
      final agreed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF22C55E), size: 24),
              SizedBox(width: 8),
              Text('Data & Privacy',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To analyze your product, we need to send your product label photos to a third-party AI service.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.photo_camera_outlined, 'What is sent:', 'Your product label photos (front & back images)'),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.cloud_outlined, 'Sent to:', 'OpenAI (third-party AI service) for ingredient analysis'),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.delete_outline, 'Storage:', 'Images are processed in real-time and NOT stored on our servers or by OpenAI'),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.lock_outline, 'Security:', 'All data is transmitted securely via encrypted HTTPS connection'),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse('https://trustlt.onrender.com/privacy-policy'), mode: LaunchMode.externalApplication),
                child: const Text(
                  'Read our full Privacy Policy',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF22C55E),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Outfit')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('I Agree & Continue', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

      if (agreed != true) return; // User cancelled
      await prefs.setBool(_consentKey, true);
    }

    // Proceed with analysis
    if (mounted) {
      AnalysisNotificationService().startAnalysis(
        frontImagePath: widget.frontImagePath,
        backImagePath: widget.backImagePath,
      );
      context.go('/home');
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF22C55E)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: 'Trust',
                style: TextStyle(color: Color(0xFF1A1A1A)),
              ),
              TextSpan(
                text: 'It',
                style: TextStyle(color: Color(0xFF22C55E)),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Front and Back labels with images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Front column
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Front',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ImagePreview(imagePath: widget.frontImagePath),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Back column
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _ImagePreview(imagePath: widget.backImagePath),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Confirm Your Selection text
            const Text(
              'Confirm Your Selection',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ready to analyze both images?',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Retake button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => context.pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFEF4444)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.close,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Retake',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Start Analysis button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _onStartAnalysis,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.document_scanner_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Start Analysis',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Image preview widget
class _ImagePreview extends StatelessWidget {
  final String? imagePath;

  const _ImagePreview({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: imagePath != null
            ? Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Color(0xFF9CA3AF),
                ),
              ),
      ),
    );
  }
}
