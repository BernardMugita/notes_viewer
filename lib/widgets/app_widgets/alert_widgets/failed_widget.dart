import 'package:flutter/material.dart';
import 'package:note_viewer/utils/app_utils.dart';

class FailedWidget extends StatefulWidget {
  final String message;

  const FailedWidget({super.key, required this.message});

  @override
  State<FailedWidget> createState() => _FailedWidgetState();
}

class _FailedWidgetState extends State<FailedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 139, 0, 0),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          widget.message,
          style: TextStyle(
              color: AppUtils.$mainWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
