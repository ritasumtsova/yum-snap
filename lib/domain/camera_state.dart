part of 'camera_cubit.dart';

abstract class CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final FlashMode flashMode;

  CameraReady({required this.controller, required this.flashMode});

  @override
  List<Object?> get props => [controller, flashMode];
}

class CameraError extends CameraState {
  final String message;

  CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
