import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

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
  bool isRightClicked = false;
  bool actionMode = false;
  Map selectedRecording = {};
  bool isSelectedRecording = false;
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileExtension = widget.material['file'].split('.')[1];

    final String url = AppUtils.$serverDir;

    final user = context.read<UserProvider>().user;

    Future<void> onRightClick(PointerDownEvent event) async {
      if (event.kind == PointerDeviceKind.mouse &&
          (event.buttons & kSecondaryMouseButton) != 0) {
        setState(() {
          isRightClicked = !isRightClicked;
          actionMode = !actionMode;

          if (selectedRecording.isNotEmpty) {
            selectedRecording.clear();
          } else {
            selectedRecording['id'] = widget.material;
            isSelectedRecording =
                selectedRecording['id']['id'] == widget.material['id'];
          }
        });
      }
    }

    return GestureDetector(
      onTap: () {
        context.go('/units/notes/${widget.lesson}/${widget.fileName}', extra: {
          "path": "$url/${widget.material['file']}",
          "material": widget.material,
          "featured_material":
              widget.notes.isEmpty ? widget.slides : widget.notes,
        });
      },
      child: Listener(
        onPointerDown: onRightClick,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppUtils.mainWhite(context),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: isSelectedRecording && actionMode
                          ? AppUtils.mainBlue(context)
                          : AppUtils.mainGrey(context))),
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              margin: const EdgeInsets.only(bottom: 5),
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
                                      : AppUtils.mainBlue(context)
                                          .withOpacity(0.3),
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
                        style: TextStyle(
                            fontSize: 16,
                            color: isSelectedRecording && actionMode
                                ? AppUtils.mainBlue(context)
                                : AppUtils.mainBlack(context),
                            fontWeight: isSelectedRecording && actionMode
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
                ],
              ),
            ),
            if (user.isNotEmpty &&
                user['role'] == 'admin' &&
                isSelectedRecording &&
                actionMode)
              Positioned(
                right: 25,
                top: 5,
                child: SizedBox(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isRightClicked = false;
                                // _showDialog(context,
                                //     courses: courses, token: tokenRef);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppUtils.mainGreen(context)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Row(
                              children: [
                                Icon(FluentIcons.edit_24_regular,
                                    color: AppUtils.mainWhite(context)),
                                const Gap(5),
                                Text("Edit",
                                    style: TextStyle(
                                        color: AppUtils.mainWhite(context))),
                              ],
                            )),
                        Gap(5),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isRightClicked = false;
                                _showDeleteDialog(context);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    AppUtils.mainRed(context)),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Row(
                              children: [
                                Icon(FluentIcons.delete_24_regular,
                                    color: AppUtils.mainWhite(context)),
                                const Gap(5),
                                Text("Delete",
                                    style: TextStyle(
                                        color: AppUtils.mainWhite(context))),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext content) {
    showDialog(
        context: content,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppUtils.mainWhite(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 300,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.delete_24_regular,
                      color: AppUtils.mainRed(context),
                      size: 80,
                    ),
                    Gap(20),
                    Text(
                      "Confirm Delete",
                      style: TextStyle(
                          fontSize: 18, color: AppUtils.mainRed(context)),
                    ),
                    Text(
                      "Are you sure you want to delete this file? Note that this action is irreversible.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainBlueAccent(context)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.dismiss_24_filled,
                                        color: AppUtils.mainRed(context)),
                                    const Gap(5),
                                    Text("Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.mainRed(context))),
                                  ],
                                ))),
                        Gap(10),
                        Expanded(
                          child: Consumer<UploadsProvider>(
                              builder: (context, uploadsProvider, _) {
                            return ElevatedButton(
                                onPressed: uploadsProvider.isLoading
                                    ? null
                                    : () {
                                        uploadsProvider.deleteUploadedMaterial(
                                            tokenRef,
                                            selectedRecording['id']['id']);
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.pop(context);
                                        });
                                      },
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(10)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainRed(context)),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)))),
                                child: uploadsProvider.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(FluentIcons.delete_24_regular,
                                              color:
                                                  AppUtils.mainWhite(context)),
                                          const Gap(5),
                                          Text("Delete",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppUtils.mainWhite(
                                                      context))),
                                        ],
                                      ));
                          }),
                        )
                      ],
                    ))
                  ],
                )),
          );
        });
  }
}
