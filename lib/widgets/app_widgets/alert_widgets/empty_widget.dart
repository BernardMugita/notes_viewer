import 'package:flutter/material.dart';
import 'package:maktaba/responsive/responsive_layout.dart';
import 'package:maktaba/utils/app_utils.dart';

class EmptyWidget extends StatefulWidget {
  final String errorHeading;
  final String errorDescription;
  final String image;

  const EmptyWidget(
      {super.key,
      required this.errorHeading,
      required this.errorDescription,
      required this.image});

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: _buildEmptyWidget(0.4, 150, 150),
        tabletLayout: _buildEmptyWidget(0.4, 200, 200),
        desktopLayout: _buildEmptyWidget(0.4, 200, 200));
  }

  Widget _buildEmptyWidget(
    double heightDenomenator,
    double imageHeight,
    double imageWidth,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * heightDenomenator,
      decoration: BoxDecoration(
          color: AppUtils.mainWhite(context),
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.errorHeading,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold)),
              Image(
                  fit: BoxFit.contain,
                  width: imageWidth,
                  height: imageHeight,
                  image: AssetImage(widget.image)),
              Text(widget.errorDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ))
            ]),
      ),
    );
  }
}
