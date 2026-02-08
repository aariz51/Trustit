import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

/// Camera Screen - Matches designs 16-19.png
/// Full screen camera with instruction banner, capture button, and gallery access
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String _currentInstruction = 'Take clear photo of the front';
  bool _isCapturingFront = true;
  XFile? _frontImage;
  XFile? _backImage;
  bool _flashEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
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

  Future<void> _captureImage() async {
    if (_controller == null || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();

      if (_isCapturingFront) {
        setState(() {
          _frontImage = image;
          _isCapturingFront = false;
          _currentInstruction = 'Take clear photo of the ingredients';
        });
      } else {
        setState(() {
          _backImage = image;
        });
        // Navigate to confirm screen with both images
        if (mounted) {
          context.push('/confirm', extra: {
            'front': _frontImage?.path,
            'back': _backImage?.path,
          });
        }
      }
    } catch (e) {
      debugPrint('Capture error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _toggleFlash() {
    if (_controller == null) return;
    setState(() {
      _flashEnabled = !_flashEnabled;
      _controller!.setFlashMode(
        _flashEnabled ? FlashMode.torch : FlashMode.off,
      );
    });
  }

  /// Open gallery to pick images
  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      // Pick front image
      final XFile? frontImage = await picker.pickImage(source: ImageSource.gallery);
      if (frontImage == null) return;
      
      // Pick back/ingredients image
      if (mounted) {
        final XFile? backImage = await picker.pickImage(source: ImageSource.gallery);
        if (backImage == null) return;
        
        // Navigate to confirm screen with both images
        if (mounted) {
          context.push('/confirm', extra: {
            'front': frontImage.path,
            'back': backImage.path,
          });
        }
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar to light for dark camera background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview - Fill entire screen
          if (_isInitialized && _controller != null)
            LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                var scale = size.aspectRatio * _controller!.value.aspectRatio;
                
                // Invert to cover screen (crop rather than letterbox)
                if (scale < 1) scale = 1 / scale;
                
                return ClipRect(
                  child: Transform.scale(
                    scale: scale,
                    child: Center(
                      child: CameraPreview(_controller!),
                    ),
                  ),
                );
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // White scan frame overlay
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 140),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Close button - top left corner
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // Flash button - top right corner
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: _toggleFlash,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _flashEnabled ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // Instruction banner - positioned inside the scan frame at top
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _currentInstruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery button
                    GestureDetector(
                      onTap: _openGallery,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Capture button
                    GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _isCapturing ? Colors.grey : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Progress indicator (front/back)
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isCapturingFront
                                    ? Colors.white
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: !_isCapturingFront
                                    ? Colors.white
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
