import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';

class FailedWidget extends StatefulWidget {
  final String message;

  const FailedWidget({super.key, required this.message});

  @override
  State<FailedWidget> createState() => _FailedWidgetState();
}

class _FailedWidgetState extends State<FailedWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: _builfFailedWidget(14, 10, 5),
        tabletLayout: _builfFailedWidget(16, 20, 10),
        desktopLayout: _builfFailedWidget(16, 20, 10));
  }

  Widget _builfFailedWidget(
      double failedFontSize, double verticalPadding, double horizontalPadding) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      decoration: BoxDecoration(
          color: AppUtils.mainRed(context),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          widget.message,
          style: TextStyle(
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
              fontSize: failedFontSize),
        ),
      ),
    );
  }
}
