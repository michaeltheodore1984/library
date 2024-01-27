import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_library/util.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class UploadWidget extends StatefulWidget {
  const UploadWidget({super.key});

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  late ImagePicker? imagePicker;
  // Using localhost for testing
  var uploadUrl = '192.168.1.2:3000';
  late File? localImageFile;
  var box = GetStorage();
  late bool? success;
  late XFile? imageToUpload;

  @override
  void initState() {
    super.initState();
    localImageFile = null;
    imagePicker = ImagePicker();
    imageToUpload = null;
    success = null;
    // Get image path from local storage
    // TODO: insert path into device database
    if (box.read('localImagePath') != null) {
      var p = box.read('localImagePath');
      localImageFile = File(p);
    }
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
                var prm = await Util.getPermission(Permission.photos);
                // Check for permission. PermissionStatus.limited is the user's
                // choice to grant only certain photos for processing.
                if (prm == PermissionStatus.granted ||
                    prm == PermissionStatus.limited) {
                  // Show the image picker
                  List<XFile> files = await imagePicker!.pickMultiImage();
                  if(files.isEmpty) {
                    return;
                  }
                  /* var file =
                      await imagePicker!.pickImage(source: ImageSource.gallery);

                  // User pressed cancel
                  if (file == null) {
                    return;
                  } */

                  // Build the image upload uri
                  var uri = Uri.http(uploadUrl, '/api/upload');

                  var uploadList = <MultipartFile>[];
                  for(var f in files) {
                    uploadList.add(await MultipartFile.fromPath('file', f.path));
                  }

                  /* // Build the image upload request
                  var request = http.MultipartRequest('POST', uri)
                    // Email field for auth
                    ..fields['json_data'] = 'abc123:def456'
                    // Use the image path to build a multipart file
                    ..files.add(await http.MultipartFile.fromPath(
                        'file', file!.path,
                        contentType: MediaType('image', '*'))); */

                  var request = MultipartRequest('POST', uri)
                    ..fields['json_data'] = 'abc123:def456'
                    ..files.addAll(uploadList);
                  // Send the photo to the server
                  var response = await request.send();
                  var streamedResponse = await Response.fromStream(response);
                  var streamArr = streamedResponse.body.split(',');
                  for(var item in streamArr) {
                    item = item.replaceAll('[', ''); 
                    item = item.replaceAll(']', '');
                    item = item.replaceAll('"', '');
                    item = item.replaceAll('./uploads/', '/api/image/');
                    // TODO: send each image with fcm. var totalPath = '<host>'+item
                  }
                
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
                } else {
                  // TODO: show rationale
                  return;
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
          ),
          ElevatedButton(
              onPressed: () async {
                // Download the image from the server
                if (imageToUpload != null) {
                  var response = await http.get(Uri.http(
                      uploadUrl, '/api/image/abc123/${imageToUpload!.path}'));
                  // Set the documents directory on the device
                  Directory documentDirectory =
                      await getApplicationDocumentsDirectory();

                  // Save the file with an arbitrary name or give it any name
                  // as long as it can be retrieved easily in the future.
                  File file = File(join(documentDirectory.path, 'local.jpg'));

                  // Save the file to the device storage
                  await file.writeAsBytes(response.bodyBytes);

                  // Save image path to local storage.
                  // TODO: save image path to device database
                  box.write('localImagePath', file.path);

                  // Update the image file state and show in UI
                  setState(() {
                    localImageFile = file;
                  });
                }
              },
              child: const Text('Get Images')),
          localImageFile != null
              ? Expanded(
                  child: Image.file(
                    localImageFile!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container()
        ],
      ),
    ));
  }
}
