import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/toast.dart';

class UploadProvider extends ChangeNotifier {
  File _file = File("zz");
  Uint8List webImage = Uint8List(10);

  bool get isUnAssigned => _file.path == "zz";
  bool get isWeb => kIsWeb ? true : false;
  File get getFile => _file;

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
  }

  uploadImage() async {
    var permissionStatus = requestPermissions();
    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        _file = selected;
      } else {
        showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        _file = File("a");
        webImage = f;
      } else {
        showToast("No file selected");
      }
    } else {
      showToast("Permission not granted");
    }
    notifyListeners();
  }
}
