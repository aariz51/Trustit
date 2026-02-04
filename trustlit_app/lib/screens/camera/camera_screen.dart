import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../config/app_colors.dart';

/// Camera Screen - Based on 9.png, 10.png
/// Handles camera preview, capture, flash toggle, gallery access
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isFlashOn = false;
  bool _isFrontCaptured = false;
  String? _frontImagePath;
  String? _backImagePath;
  bool _hasPermission = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    setState(() {
      _hasPermission = true;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _hasPermission ? _buildCameraView() : _buildPermissionRequest(),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 48,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Camera Access Required',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'To scan products, we need access to your camera. Please grant permission to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => openAppSettings(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        // Camera Preview
        if (_isInitialized && _controller != null)
          Positioned.fill(
            child: CameraPreview(_controller!),
          )
        else
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
          ),

        // Header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                // Title
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'Reveal',
                        style: TextStyle(color: AppColors.white),
                      ),
                      TextSpan(
                        text: 'It',
                        style: TextStyle(color: AppColors.primaryGreen),
                      ),
                    ],
                  ),
                ),
                // Flash Toggle
                IconButton(
                  onPressed: _toggleFlash,
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Instruction Banner
        Positioned(
          top: 100,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isFrontCaptured
                        ? 'Take clear photo of the ingredients'
                        : 'Take clear photo of front',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Text(
                  _isFrontCaptured ? '2/2' : '1/2',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Button
                GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Capture Button
                GestureDetector(
                  onTap: _isCapturing ? null : _capturePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: _isCapturing
                              ? AppColors.textLightGray
                              : AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _isCapturing
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // Placeholder for alignment
                const SizedBox(width: 50, height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();

      if (!_isFrontCaptured) {
        setState(() {
          _frontImagePath = image.path;
          _isFrontCaptured = true;
          _isCapturing = false;
        });
      } else {
        setState(() {
          _backImagePath = image.path;
          _isCapturing = false;
        });

        // Navigate to confirm screen
        if (mounted) {
          context.push('/confirm', extra: {
            'frontImagePath': _frontImagePath,
            'backImagePath': _backImagePath,
          });
        }
      }
    } catch (e) {
      debugPrint('Capture error: $e');
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      if (!_isFrontCaptured) {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _frontImagePath = image.path;
            _isFrontCaptured = true;
          });
        }
      } else {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          _backImagePath = image.path;

          // Navigate to confirm screen
          if (mounted) {
            context.push('/confirm', extra: {
              'frontImagePath': _frontImagePath,
              'backImagePath': _backImagePath,
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }
}
