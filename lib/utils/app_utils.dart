import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_viewer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class AppUtils {
  static Color mainBlue(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode ? const Color(0xFF2a68af) : const Color(0xFF2a68af);
  }

  static Color mainWhite(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode ? Colors.black : Color(0xFFf9f9ff);
  }

  static Color mainBlack(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode ? Colors.white : Colors.black;
  }

  static Color mainGrey(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode
        ? const Color.fromARGB(123, 42, 104, 175)
        : const Color(0xFFBEBEBE);
  }

  static Color mainShaddow(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode
        ? const Color.fromARGB(69, 42, 104, 175)
        : const Color.fromARGB(255, 224, 224, 224);
  }

  static Color mainRed(BuildContext context) {
    return const Color(0xFFFF1900);
  }

  static Color mainGreen(BuildContext context) {
    return const Color(0xFF00B327);
  }

  static Color mainBlueAccent(BuildContext context) {
    return const Color(0xFFf9f9ff);
  }

  static const String $baseUrl = 'https://r1-server.arifulib.co.ke';

  static String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('d MMMM y').format(parsedDate);
  }

  static Future<String> getTemporaryFilePath(Uint8List fileBytes) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File(
      '${tempDir.path}/tempfile_${DateTime.now().millisecondsSinceEpoch}.tmp',
    );
    await tempFile.writeAsBytes(fileBytes);
    return tempFile.path;
  }
}
