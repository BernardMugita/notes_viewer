import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/services/upload_api.dart';

class UploadsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool success = false;
  bool error = false;
  String message = '';

  UploadApi uploadApi = UploadApi();

  Future<bool> uploadNewFile(
      String token, PlatformFile file, Map<String, String> form) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final uploadRequest = await uploadApi.uploadFile(token, file, form);

      if (uploadRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        message = "File uploaded successfully";
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        error = true;
        message = "Failed to upload file";
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      error = true;
      message = "Failed to upload file $e";
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> deleteUploadedMaterial(
      String token, String materialId) async {
    isLoading = true;
    success = false;
    error = false;
    message = '';
    notifyListeners();

    try {
      final deleteRequest =
          await uploadApi.deleteUpload(materialId: materialId, token: token);

      if (deleteRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        message = "File deleted successfully";
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