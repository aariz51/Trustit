import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Confirm Screen - Matches designs 20-22.png
/// Shows front and back images side by side with Retake and Start Analysis buttons
class ConfirmScreen extends StatelessWidget {
  final String? frontImagePath;
  final String? backImagePath;

  const ConfirmScreen({
    super.key,
    this.frontImagePath,
    this.backImagePath,
  });

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
                text: 'Reveal',
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
                        _ImagePreview(imagePath: frontImagePath),
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
                        _ImagePreview(imagePath: backImagePath),
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
                        onPressed: () {
                          // Navigate to analysis screen
                          context.push('/analyzing', extra: {
                            'front': frontImagePath,
                            'back': backImagePath,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.document_scanner_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Start Analysis',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
