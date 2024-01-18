import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_library/util.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';

// Permissions widget that show how to request permissions from the user.
// This widget works with permissions for the device photo gallery. It asks
// the user to give permissions for the app to access the photors on the user's
// device. If the user denies permission a message showing why we need permissions
// will appear for the user to review.
// TODO: Create a settings page where if the user permanently denied access to photo
// gallery they can open the device settings for the app and enable access to photo gallery.
class PermissionWidget extends StatefulWidget {
  const PermissionWidget({super.key});

  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  var box = GetStorage();
  late String? pickedImagePath;
  late bool loading;
  late PermissionStatus? photosPermission;

  @override
  void initState() {
    super.initState();
    // Initilize all late fields.
    loading = false;
    pickedImagePath = null;
    photosPermission = null;
    // Read the image path from local storage
    // at startup to determine if the user
    // has a saved image path on the device.
    if (box.read('path') != null) {
      setState(() {
        pickedImagePath = box.read('path');
      });
    }
  }

  // Use a parent widget for the profile
  // photo to condense the code.
  Widget profilePicture(widget) {
    return SizedBox(
      width: 128,
      height: 128,
      child: ClipOval(child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
              body: Column(
        children: [
          Center(
            child: Stack(children: [
              // This stack is the three possible states of a profile picture.
              // Once the user has chosen a profile picture it will show up here.
              pickedImagePath != null && !loading
                  ? profilePicture(Image.file(
                      File(pickedImagePath!),
                      fit: BoxFit.cover,
                    ))
                  : loading
                      // When the user taps the edit icon for the profile picture
                      // the loading animation begins and it can be customzied.
                      // When the user has finished choosing a profile picture from
                      // the device the loading animation will stop and the picture
                      // will be displayed.
                      ? profilePicture(Container(
                          key: const Key('loading'),
                          color: Colors.grey,
                          child: Center(
                              child: LoadingAnimationWidget.prograssiveDots(
                                  color: Colors.white, size: 32))))
                      // At initial app startup the profile picture is non existent so
                      // the app shows a placeholder container with an icon.
                      : profilePicture(Container(
                          key: const Key('placeholder'),
                          color: Colors.grey,
                          child: const Center(child: Icon(Icons.portrait)))),
              // The user can tap on the edit icon button and this will bring up
              // the image picker.
              Positioned(
                right: 8,
                bottom: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xff94d500),
                  child: IconButton(
                    key: const Key('edit'),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      // Show the user the permissions dialog that requests
                      // permission for the photo gallery from the user. If
                      // the request was granted previously and either is
                      // granted or not the dialog does not appear.
                      var photoPermissionRequest =
                          await Util.getPermission(Permission.photos);

                      setState(() {
                        photosPermission = photoPermissionRequest;
                      });
                      // If the permission was granted set the loading flag
                      // to true which in turn shows the loading animation. Also
                      // set the photosPermission flag to later show the rationale if the
                      // permission was PermissionStatus.denied or PermissionStatus.permanentlyDenied.
                      if (photoPermissionRequest == PermissionStatus.granted) {
                        setState(() {
                          loading = true;
                        });
                        // Pick an image
                        var p = await _imagePicker.pickImage(
                            source: ImageSource.gallery);
                        // Check if the result is null. It is null when the user
                        // presses the cancel button instead of picking an image.
                        if (p != null) {
                          // If the result is not null save the image path to local storage
                          // for later retrieval. Saving the image path to local storage allows
                          // the app to retrieve it when this widget is initialized;
                          box.write('path', p.path);
                          // Set the pickedImagePath flag to show the image in the UI after it
                          // has been selected. This is purely from memory and if the app dies
                          // or the user presses the back button on Android they would at least
                          // have seen the image before deciding on other actions.
                          setState(() {
                            pickedImagePath = p.path;
                            // Once the image has been picked and the path saved we can cancel
                            // the loading animation.
                            loading = false;
                          });
                          // If the image was not chosen i.e. the result from the image picker
                          // was null and the loading animation was running, then cancel it.
                        } else {
                          setState(() {
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ]),
          ),
          // Conditionally render the rationale if permission to the image
          // gallery has not been given i.e. denied or permanently denied
          photosPermission != null &&
                  photosPermission != PermissionStatus.granted
              ? Padding(
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
                              'Okay. No problem. The app needs permission to upload photos from your device. You can grant permission at any time in your device settings.'),
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
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
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
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
                )
              // Show an empty container if permission to the image gallery
              // has been granted. An empty container is infinitesimally small
              // that represents a null widget
              : Container()
        ],
      ))),
    );
  }
}
