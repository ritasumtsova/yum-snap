import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:yam_snap/presentation/home_page.dart';
import 'package:yam_snap/presentation/new_meal_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late FlashMode _currentFlashMode = FlashMode.off;

  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _toggleFlash() async {
    if (_currentFlashMode == FlashMode.off) {
      await _controller.setFlashMode(FlashMode.torch);
      setState(() => _currentFlashMode = FlashMode.torch);
    } else {
      await _controller.setFlashMode(FlashMode.off);
      setState(() => _currentFlashMode = FlashMode.off);
    }
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;

    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');

      await image.saveTo(imagePath);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AddNewMealPage(imagePath: imagePath),
          ),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                      ),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: _toggleFlash,
                      icon: Icon(
                        _currentFlashMode == FlashMode.torch
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 5, child: CameraPreview(_controller)),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _takePicture(context),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color: Colors.white.withValues(alpha: .3),
                        ),
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
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
