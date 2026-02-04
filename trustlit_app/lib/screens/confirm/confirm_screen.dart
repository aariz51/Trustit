import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';

/// Confirm Screen - Based on 11.png, 22.png, 23.png
/// Shows front and back image previews with Retake and Start Analysis buttons
class ConfirmScreen extends StatelessWidget {
  final String frontImagePath;
  final String backImagePath;

  const ConfirmScreen({
    super.key,
    required this.frontImagePath,
    required this.backImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Reveal',
                style: TextStyle(color: AppColors.textBlack),
              ),
              TextSpan(
                text: 'It',
                style: TextStyle(color: AppColors.primaryGreen),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Image Previews
                    Row(
                      children: [
                        // Front Image
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Front',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDarkGray,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildImagePreview(frontImagePath),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Back Image
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDarkGray,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildImagePreview(backImagePath),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Confirmation Section
                    Text(
                      'Confirm Your Selection',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to analyze both images?',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        color: AppColors.textGray,
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Retake Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.deleteRed,
                        ),
                        label: Text(
                          'Retake',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deleteRed,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.deleteRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Start Analysis Button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _startAnalysis(context),
                        icon: Icon(
                          Icons.grid_view,
                          size: 18,
                          color: AppColors.white,
                        ),
                        label: Text(
                          'Start Analysis',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

  Widget _buildImagePreview(String imagePath) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imagePath.isNotEmpty
            ? Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        size: 48,
        color: AppColors.textLightGray,
      ),
    );
  }

  void _startAnalysis(BuildContext context) {
    // Capture navigator state before async operation
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 20),
            Text(
              'Analyzing product...',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                color: AppColors.textGray,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate analysis (TODO: Replace with actual API call)
    Future.delayed(const Duration(seconds: 2), () {
      navigator.pop(); // Close loading dialog
      router.go('/analysis', extra: {
        'analysisId': 'mock_analysis_id',
        'frontImagePath': frontImagePath,
        'backImagePath': backImagePath,
      });
    });
  }
}
