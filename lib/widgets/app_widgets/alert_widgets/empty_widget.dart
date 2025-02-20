import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/responsive/responsive_layout.dart';
import 'package:note_viewer/utils/app_utils.dart';

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
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
          color: AppUtils.mainWhite(context), borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveLayout(
                  mobileLayout: Text(widget.errorHeading,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                  tabletLayout: Text(widget.errorHeading,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold)),
                  desktopLayout: Text(widget.errorHeading,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold))),
              Gap(10),
              ResponsiveLayout(
                  mobileLayout: Image(
                      fit: BoxFit.contain,
                      width: 200,
                      height: 200,
                      image: AssetImage(widget.image)),
                  tabletLayout: Image(
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
                      image: AssetImage(widget.image)),
                  desktopLayout: Image(
                      fit: BoxFit.contain,
                      width: 200,
                      height: 200,
                      image: AssetImage(widget.image))),
              Gap(10),
              Text(widget.errorDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ))
            ]),
      ),
    );
  }
}
