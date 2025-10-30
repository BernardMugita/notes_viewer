import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maktaba/providers/theme_provider.dart';
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

    return isDarkMode ? Colors.black : Color(0xFFFFFFFF);
  }

  static Color mainBlack(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode ? Colors.white : Colors.black;
  }

  static Color backgroundPanel(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isDarkMode ? const Color(0xFF181818) : const Color(0xFFf2f4f7);
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

  // static const String $appUrl = 'https://philanthropically-farsighted-malik.ngrok-free.dev';
  static const String $appUrl = 'https://r1-server.arifulib.co.ke';
  // static const String $appUrl = 'http://127.0.0.1:8000';

  static const String $baseUrl = '${$appUrl}/r1server';

  static const String $serverDir = $appUrl;

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

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static int getMonthsDays(int year, int monthValue) {
    int currentMonthDays = 0;
    List months = [
      {'month': 1, 'days': 31},
      {'month': 2, 'days': isLeapYear(year) ? 29 : 28},
      {'month': 3, 'days': 31},
      {'month': 4, 'days': 30},
      {'month': 5, 'days': 31},
      {'month': 6, 'days': 30},
      {'month': 7, 'days': 31},
      {'month': 8, 'days': 31},
      {'month': 9, 'days': 30},
      {'month': 10, 'days': 31},
      {'month': 11, 'days': 30},
      {'month': 12, 'days': 31},
    ];

    for (var month in months) {
      if (month['month'] == monthValue) {
        currentMonthDays = month['days'];
        break;
      }
    }

    return currentMonthDays;
  }

  static String toSentenceCase(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes minute${minutes != 1 ? 's' : ''} ${seconds.toString().padLeft(2, '0')} second${seconds != 1 ? 's' : ''} left";
  }
}
