import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'db.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController textController = TextEditingController();
  var messages = <Message>[];
  late File? imageFile;

  Future getImageFile() async {
    // Get the image url from the server
    // then save it locally.
    var remoteImagePath = '/api/image/abc123/def456/1706214134.7937741.jpg';
    var uri = Uri.http('192.168.1.2:3000', remoteImagePath);
    var response = await http.get(uri);

    // Get the documents directory
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    // Save the file with an arbitrary name or give it any name
    // as long as it can be retrieved easily in the future.
    File file = File(join(documentDirectory.path, '1706214134.7937741.jpg'));

    // Write the file to disk
    await file.writeAsBytes(response.bodyBytes);

    // Add the message that includes the device file path.
    setState(() {
      messages.add(Message('notext', file.path));
    });
  }

  @override
  void initState() {
    super.initState();

    // Use a button instead of initstate
    // getImageFile();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index].message;
                var image = messages[index].localImagePath;
                return Container(
                    child: image != 'def_image_file_path'
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 300,
                            child: ClipRRect(
                              child: Image.file(File(image)),
                            ))
                        : Text(message));
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                ),
              ),
              FloatingActionButton.small(
                onPressed: () {
                  getImageFile();
                },
              )
            ],
          )
        ],
      ),
    ));
  }
}
