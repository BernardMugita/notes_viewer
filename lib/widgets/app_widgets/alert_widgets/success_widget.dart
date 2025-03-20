import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
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
    return ResponsiveLayout(
        mobileLayout: _builfSuccessWidget(14, 10, 5),
        tabletLayout: _builfSuccessWidget(16, 20, 10),
        desktopLayout: _builfSuccessWidget(16, 20, 10));
  }

  Widget _builfSuccessWidget(double successFontSize, double verticalPadding,
      double horizontalPadding) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 74, 139, 0),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          widget.message,
          style: TextStyle(
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
              fontSize: successFontSize),
        ),
      ),
    );
  }
}
