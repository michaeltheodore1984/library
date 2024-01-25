import 'package:flutter/material.dart';
import 'package:flutter_library/chat.dart';
import 'package:flutter_library/drag.dart';
import 'package:flutter_library/permission.dart';
import 'package:flutter_library/scroll.dart';
import 'package:flutter_library/sheet.dart';
import 'package:flutter_library/ui.dart';
import 'package:flutter_library/upload.dart';
import 'package:get_storage/get_storage.dart';

import 'db.dart';

// A library of flutter widgets doing cool things.
// The code found in the lib folder will be used as reusable code in projects.
// TODO: encrypted local storage for sensitive data.
void main() async {
  // Initialize Fluter bindings
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local storage.
  await GetStorage.init();
  var box = GetStorage();
  // Check if database was initialized
  if (box.read('scaffold') == false || box.read('scaffold') == null) {
    Db.scaffold();
    // Database has been initialized and test data has been inserted
    box.write('scaffold', true);
  }
  // Run the app. The home property will call different widgets as they are developed.
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Chat(),
    // home: UploadWidget(),
    // home: ScrollWidget(),
    // home: ExampleDragAndDrop(),
    // home: Sheet(),
    // home: PermissionWidget()
    // home: UploadWidget()
  ));
}
