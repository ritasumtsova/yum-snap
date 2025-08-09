import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionHandler {
  static Future<bool> checkAndRequestPermission(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You need to grant access to use camera based features.',
          ),
        ),
      );
      await openAppSettings();
      return false;
    }
    return false;
  }
}
