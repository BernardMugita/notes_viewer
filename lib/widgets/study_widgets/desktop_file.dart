import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/utils/app_utils.dart';

class DesktopFile extends StatefulWidget {
  final String fileName;
  final String lesson;
  final Map material;
  final IconData? icon;
  final List notes;
  final List slides;

  const DesktopFile(
      {super.key,
      required this.fileName,
      required this.lesson,
      required this.material,
      required this.icon,
      required this.notes,
      required this.slides});

  @override
  State<DesktopFile> createState() => _DesktopFileState();
}

class _DesktopFileState extends State<DesktopFile> {
  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.material['file'].split('.')[1];

    final String url = AppUtils.$baseUrl;

    return GestureDetector(
      onTap: () {
        context.go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
          "path": "$url/${widget.material['file']}",
          "material": widget.material,
          "featured_material":
              widget.notes.isEmpty ? widget.slides : widget.notes,
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
                ),
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
