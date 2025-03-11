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

    final String url = AppUtils.$serverDir;

    print(widget.material);

    return GestureDetector(
      onTap: () {
        context.go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
          "path": "$url/${widget.material['file']}",
          "material": widget.material,
          "featured_material":
              widget.notes.isEmpty ? widget.slides : widget.notes,
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppUtils.mainWhite(context),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppUtils.mainGrey(context))),
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            CircleAvatar(
                backgroundColor: fileExtension == 'pdf'
                    ? AppUtils.mainRed(context).withOpacity(0.3)
                    : fileExtension == 'docx'
                        ? AppUtils.mainBlue(context).withOpacity(0.3)
                        : fileExtension == 'xlxs'
                            ? const Color.fromARGB(255, 100, 187, 0)
                            : fileExtension == 'ppt'
                                ? Colors.orange.withOpacity(0.3)
                                : AppUtils.mainBlue(context).withOpacity(0.3),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: fileExtension == 'pdf'
                      ? AppUtils.mainRed(context)
                      : fileExtension == 'docx'
                          ? AppUtils.mainBlue(context)
                          : fileExtension == 'xlxs'
                              ? const Color.fromARGB(255, 100, 187, 0)
                              : fileExtension == 'ppt'
                                  ? Colors.orange
                                  : AppUtils.mainBlue(context),
                )),
            Gap(10),
            SizedBox(
              child: Text(widget.material['name'] ?? 'material',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
