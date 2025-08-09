import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yam_snap/presentation/cubits/camera/camera_cubit.dart';
import 'package:yam_snap/presentation/pages/new_meal_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    context.read<CameraCubit>().initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          if (state is CameraLoading || state is CameraInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (state is CameraError) {
            return Center(child: Text(state.message));
          }

          if (state is CameraReady) {
            final cubit = context.read<CameraCubit>();

            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: cubit.toggleFlash,
                          icon: Icon(
                            state.flashMode == FlashMode.torch
                                ? Icons.flash_off
                                : Icons.flash_on,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 5, child: CameraPreview(state.controller)),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          final path = await cubit.takePicture();
                          if (path != null && context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => AddNewMealPage(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
