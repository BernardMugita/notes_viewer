import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:http/http.dart' as http;

class UploadApi {
  final String url = AppUtils.$baseUrl;

  Future<Map<String, dynamic>> uploadFile(
      String token, PlatformFile file, Map<String, String> form) async {
    try {
      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$url/uploads/upload_material'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Check if we are on web or non-web platforms
      if (file.bytes != null) {
        // Web - use file.bytes for uploading
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        // Non-web platforms (e.g., Android, iOS) - use file.path
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );
      }

      // Add form data
      request.fields['form'] = jsonEncode(form);

      // Send the request
      final response = await request.send();

      // Get the response body as a string
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to upload file: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<Map<String, dynamic>> deleteUpload(
      {required String token, required String materialId}) async {
    try {
      final getUserUnitsRequest = await http.post(
        Uri.parse('$url/uploads/delete_material'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          'id': materialId,
        }),
      );
      return jsonDecode(getUserUnitsRequest.body);
    } catch (e) {
      throw Exception('Failed to delete upload: $e');
    }
  }
}
