import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';

class SuccessWidget extends StatefulWidget {
  final String message;

  const SuccessWidget({super.key, required this.message});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 74, 139, 0),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          widget.message,
          style: TextStyle(
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }
}
