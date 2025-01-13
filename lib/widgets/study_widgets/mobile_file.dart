import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class MobileFile extends StatefulWidget {
  final String fileName;
  final IconData? icon;

  const MobileFile({super.key, required this.fileName, this.icon});

  @override
  State<MobileFile> createState() => _MobileFileState();
}

class _MobileFileState extends State<MobileFile> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/units/study/Introduction to Anatomy/${widget.fileName}',
        );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.height / 8,
            height: MediaQuery.of(context).size.height / 8,
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
                child: Icon(
              widget.icon,
              size: 50,
              color: fileExtension == 'pdf'
                  ? AppUtils.$mainRed
                  : fileExtension == 'docx'
                      ? AppUtils.$mainBlue
                      : fileExtension == 'xlxs'
                          ? const Color.fromARGB(255, 100, 187, 0)
                          : fileExtension == 'ppt'
                              ? Colors.orange
                              : AppUtils.$mainBlue,
            )),
          ),
          Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.height / 6,
            child: Text(widget.fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}