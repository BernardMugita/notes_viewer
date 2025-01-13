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

  static const String $baseUrl = 'https://1b47-41-90-172-240.ngrok-free.app';

  static String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('d MMMM y')
        .format(parsedDate); // Formats as '20th March 2025'
  }
}
