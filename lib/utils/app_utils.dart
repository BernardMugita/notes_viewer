import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  static const Color $mainBlue = Color(0xFF2a68af);
  static const Color $mainWhite = Colors.white;
  static const Color $mainBlack = Colors.black;
  static const Color $mainGrey = Color(0xFFBEBEBE);
  static const Color $mainRed = Color(0xFFFF1900);
  static const Color $mainGreen = Color(0xFF88FF00);
  static const Color $mainBlueAccent = Color(0xFFf9f9ff);

  static const String $baseUrl = 'http://127.0.0.1:8000';

  static String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('d MMMM y')
        .format(parsedDate); // Formats as '20th March 2025'
  }

  static Future<String> getTemporaryFilePath(Uint8List fileBytes) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File(
        '${tempDir.path}/tempfile_${DateTime.now().millisecondsSinceEpoch}.tmp');
    await tempFile.writeAsBytes(fileBytes);
    return tempFile.path;
  }
}
