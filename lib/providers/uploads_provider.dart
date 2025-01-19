import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:note_viewer/services/upload_api.dart';

class UploadsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';

  UploadApi uploadApi = UploadApi();

  Future<Map<String, dynamic>> uploadNewFile(
      String token, PlatformFile file, String form) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    print("Uploading");

    try {
      final uploadRequest = await uploadApi.uploadFile(token, file, form);

      print(uploadRequest);

      if (uploadRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        message = "File uploaded successfully";
        notifyListeners();
      } else {
        isLoading = false;
        error = true;
        message = "Failed to upload file";
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      error = true;
      message = "Failed to upload file $e";
      notifyListeners();
    }

    return {};
  }
}
