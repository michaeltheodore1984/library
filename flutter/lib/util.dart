import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Util {
  static getPermission(Permission permission) async {
    return await permission.request();
  }

  static Widget showRationale(PermissionStatus? photosPermission) {
    // Conditionally render the rationale if permission to the image
    // gallery has not been given i.e. denied or permanently deined
    if (photosPermission != null &&
        (photosPermission == PermissionStatus.permanentlyDenied ||
            photosPermission == PermissionStatus.denied)) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'Okay. No problem. Fresco needs permission to upload photos from your device. You can grant permission at any time in your device settings.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Button that goes to the device settings when tapped.
                    // The device settings shows the app title and permissions
                    // the user can grant or keep as denied. If the user keeps
                    // the permission denied indefinitely they can go to the app's
                    // settings and begin the grant process from there.
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        openAppSettings();
                      },
                      child: const Text('ALLOW'),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    // Dismiss the rationale. If the user dismisses the
                    // rationale they have the option to open the device
                    // settings from the app's settings screen.
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          // closeRationale();
                        },
                        child: const Text('DISMISS')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return
          // Show an empty container if permission to the image gallery
          // has been granted. An empty container is infinitesimally small
          // that represents an empty placeholder widget.
          Container();
    }
  }
}
