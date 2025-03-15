import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maktaba/services/upload_api.dart';

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

    try {
      final uploadRequest = await uploadApi.uploadFile(token, file, form);

      if (uploadRequest['status'] == 'success') {
        isLoading = false;
        success = true;
        message = "File uploaded successfully";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        isLoading = false;
        error = true;
        message = "Failed to upload file";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
      }
    } catch (e) {
      isLoading = false;
      error = true;
      message = "Failed to upload file $e";
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        error = false;
        message = '';
        notifyListeners();
      });
    }

    return {};
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
        Future.delayed(const Duration(seconds: 3), () {
          success = false;
          message = '';
          notifyListeners();
        });
      } else {
        isLoading = false;
        error = true;
        message = "Failed to upload file";
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          error = false;
          message = '';
          notifyListeners();
        });
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
