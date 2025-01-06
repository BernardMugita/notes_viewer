import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class TabletRecording extends StatefulWidget {
  final String fileName;
  final IconData? icon;

  const TabletRecording({
    super.key,
    required this.fileName,
    this.icon,
  });

  @override
  State<TabletRecording> createState() => _TabletRecordingState();
}

class _TabletRecordingState extends State<TabletRecording> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.height / 3.5,
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(
              color: const Color(0xFFf9f9ff),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 224, 224, 224),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(10, 5),
                )
              ]),
          padding: const EdgeInsets.all(20),
          child: Center(
              child: CircleAvatar(
            radius: 40,
            child: Icon(
              widget.icon,
              size: 50,
              color: AppUtils.$mainBlue,
            ),
          )),
        ),
        Gap(20),
        SizedBox(
            width: 150,
            child: Text(widget.fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18))),
      ],
    );
  }
}
