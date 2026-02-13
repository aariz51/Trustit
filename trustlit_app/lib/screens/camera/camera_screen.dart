import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

/// Camera Screen - Redesigned to match reference design
/// X and Flash buttons outside the frame at top.
/// Big rounded frame containing: instruction text, camera preview, capture button, gallery button.
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

    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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

          // Close button - top left corner (OUTSIDE the frame)
          Positioned(
            top: topPadding + 12,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Flash button - top right corner (OUTSIDE the frame)
          Positioned(
            top: topPadding + 12,
            right: 16,
            child: GestureDetector(
              onTap: _toggleFlash,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _flashEnabled ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Big scan frame containing everything else
          Positioned(
            top: topPadding + 70,
            left: 20,
            right: 20,
            bottom: bottomPadding + 16,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  // Instruction banner inside the frame at the top
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _currentInstruction,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Spacer to push controls to bottom
                  const Spacer(),

                  // Bottom controls inside the frame
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gallery button
                        GestureDetector(
                          onTap: _openGallery,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),

                        const SizedBox(width: 32),

                        // Capture button
                        GestureDetector(
                          onTap: _captureImage,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _isCapturing ? Colors.grey.shade400 : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),

                        // Spacer to balance layout 
                        const SizedBox(width: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
