import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraController? _controller;

  CameraCubit() : super(CameraInitial());

  Future<void> initializeCamera() async {
    emit(CameraLoading());
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller?.initialize();

      emit(CameraReady(controller: _controller!, flashMode: FlashMode.off));
    } catch (e) {
      emit(CameraError('Failed to initialize camera: $e'));
    }
  }

  Future<void> toggleFlash() async {
    if (_controller == null) return;
    final current = state;

    if (current is CameraReady) {
      final newMode = current.flashMode == FlashMode.off
          ? FlashMode.torch
          : FlashMode.off;

      await _controller?.setFlashMode(newMode);
      emit(CameraReady(controller: _controller!, flashMode: newMode));
    }
  }

  Future<String?> takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return null;

      final image = await _controller?.takePicture();
      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');
      await image?.saveTo(imagePath);

      emit(CameraPictureTaken(imagePath));

      return imagePath;
    } catch (e) {
      emit(CameraError('Error taking picture: $e'));
      return null;
    }
  }

  void disposeCamera() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
