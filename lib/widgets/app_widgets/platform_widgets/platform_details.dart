import 'package:flutter/material.dart';
import 'package:note_viewer/utils/app_utils.dart';

class PlatformDetails extends StatelessWidget {
  const PlatformDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Platform",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppUtils.$mainBlue,
          ),
        ),
        Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/alib-hd-shaddow.png')),
        Text(
          "Maktaba by Aarifu Library",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("Version: 1.0.0"),
      ],
    );
  }
}
