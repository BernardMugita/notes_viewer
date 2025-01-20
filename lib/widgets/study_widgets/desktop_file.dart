import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class DesktopFile extends StatefulWidget {
  final String fileName;
  final String lesson;
  final IconData? icon;

  const DesktopFile(
      {super.key,
      required this.fileName,
      required this.lesson,
      required this.icon});

  @override
  State<DesktopFile> createState() => _DesktopFileState();
}

class _DesktopFileState extends State<DesktopFile> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.fileName.split('.')[1];

    String uploadType = fileExtension == 'pdf' ? 'notes' : 'slides';

    final String url = AppUtils.$baseUrl;
    final Map lesson = context.read<LessonsProvider>().lesson;

    return GestureDetector(
      onTap: () {
        context.go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
          "path": "$url/${lesson['path']}/$uploadType/${widget.fileName}"
        });
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.height / 3.75,
            height: MediaQuery.of(context).size.height / 6,
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
              size: 70,
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
            width: 150,
            child: Text(widget.fileName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
