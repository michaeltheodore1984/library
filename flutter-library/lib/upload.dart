import 'package:flutter/material.dart';
import 'package:flutter_library/util.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late ImagePicker? imagePicker;
  // Using localhost for testing
  var uploadUrl = '192.168.1.2:3000';
  late bool? success;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    success = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // Similar to permission.dart the app wants to upload
          // a profile picture or any picture that the user wants
          // to upload. We assume permissions have been granted here.

          ElevatedButton(
              onPressed: () async {
                // Check for permission
                if (await Util.getPermission(Permission.photos) !=
                    PermissionStatus.granted) {
                  // TODO: show rationale
                  return;
                }
                var file =
                    await imagePicker!.pickImage(source: ImageSource.gallery);

                // Build the image upload uri
                var uri = Uri.http(uploadUrl, '/api/upload');

                // Build the image upload request
                var request = http.MultipartRequest('POST', uri)
                  // Email field for auth
                  ..fields['json_data'] = 'email:mike@email.com'
                  // Use the image path to build a multipart file
                  ..files.add(await http.MultipartFile.fromPath(
                      'file', file!.path,
                      contentType: MediaType('image', '*')));

                // Send the photo to the server
                var response = await request.send();

                // Handle response status code. Show either success or failure message.
                if (response.statusCode == 200) {
                  setState(() {
                    success = true;
                  });
                } else {
                  setState(() {
                    success = false;
                  });
                }
              },
              child: const Text('CHOOSE PHOTO')),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  // Show succes or failure messages
                  success != null
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: success == true
                              ? const Text(
                                  'Your photo was uploaded successfully.')
                              : success == false
                                  ? const Text(
                                      'There was a problem uploading your photo.')
                                  : Container())
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
