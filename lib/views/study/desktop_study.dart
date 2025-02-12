import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/uploads_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_file.dart';
import 'package:note_viewer/widgets/study_widgets/desktop_recording.dart';
import 'package:provider/provider.dart';

class DesktopStudy extends StatefulWidget {
  const DesktopStudy({super.key});

  @override
  State<DesktopStudy> createState() => _DesktopStudyState();
}

class _DesktopStudyState extends State<DesktopStudy> {
  String tokenRef = '';
  String lessonIdRef = '';
  String unitIdRef = '';
  String lessonNameRef = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController uploadTypeController = TextEditingController();

  List uploadTypes = ['notes', 'slides', 'recordings'];
  List<String> form = [];

  List notes = [];
  List slides = [];
  List recordings = [];
  List contributions = [];

  bool isMaterialsEmpty = false;

  FilePickerResult? result;
  String? selectedFileName;
  PlatformFile? selectedFile;
  bool isUploading = false;
  File? file;

  void pickFile() async {
    try {
      setState(() {
        isUploading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          selectedFileName = result!.files.first.name;
          selectedFile = result!.files.first;
        });
      }

      setState(() {
        isUploading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();

      final String token = authProvider.token ?? '';
      final state = GoRouter.of(context).state;

      final lessonId =
          state!.extra != null ? (state.extra as Map)['lesson_id'] : null;

      final unitId =
          state.extra != null ? (state.extra as Map)['unit_id'] : null;

      final lessonName =
          state.extra != null ? (state.extra as Map)['lesson_name'] : null;

      if (lessonId.isNotEmpty) {
        lessonIdRef = lessonId;
        unitIdRef = unitId;
        lessonNameRef = lessonName;
      }

      if (token.isNotEmpty) {
        tokenRef = token;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lesson = context.watch<LessonsProvider>().lesson;
    final user = context.watch<UserProvider>().user;

    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

    if (lesson.isNotEmpty && lesson['materials'] != null) {
      setState(() {
        notes = lesson['materials']['notes'] ?? [];
        slides = lesson['materials']['slides'] ?? [];
        recordings = lesson['materials']['recordings'] ?? [];
        contributions = lesson['materials']['contributions'] ?? [];
      });
    } else {
      print('Lesson or files are null');
    }

    if (!context.watch<LessonsProvider>().isLoading &&
        notes.isEmpty &&
        slides.isEmpty &&
        recordings.isEmpty &&
        contributions.isEmpty) {
      setState(() {
        isMaterialsEmpty = true;
      });
    }

    return Consumer<LessonsProvider>(
        builder: (BuildContext context, lessonsProvider, _) {
      return Scaffold(
        body: Flex(
          direction: Axis.horizontal,
          children: [
            isMinimized
                ? Expanded(
                    flex: 1,
                    child: SideNavigation(),
                  )
                : SizedBox(
                    width: 80,
                    child: SideNavigation(),
                  ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 20, bottom: 20),
                child: lessonsProvider.isLoading
                    ? LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.$mainBlue, size: 100)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Units/Notes/${lesson['name']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppUtils.$mainGrey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(5),
                              Text(
                                lesson['name'] ?? "Lesson name",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppUtils.$mainBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user.isNotEmpty && user['role'] == 'admin')
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                          const EdgeInsets.all(20)),
                                      backgroundColor: WidgetStatePropertyAll(
                                          AppUtils.$mainBlue),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showDialog(context);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Upload file",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.$mainWhite,
                                          ),
                                        ),
                                        const Gap(5),
                                        Icon(
                                          FluentIcons.book_add_24_regular,
                                          size: 16,
                                          color: AppUtils.$mainWhite,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Gap(20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: AppUtils.$mainWhite),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Study material",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: AppUtils.$mainGrey)),
                                  const Gap(20),
                                  if (isMaterialsEmpty)
                                    Expanded(
                                        child: Center(
                                      child: EmptyWidget(
                                          errorHeading: "How Empty!",
                                          errorDescription:
                                              "There's no study material for this lesson",
                                          image: 'assets/images/404.png'),
                                    ))
                                  else
                                    Wrap(
                                      spacing: 40,
                                      runSpacing: 40,
                                      children: [
                                        // Map notes to DesktopFile widgets and convert to list
                                        ...notes.map((note) {
                                          return DesktopFile(
                                            notes: notes,
                                            slides: [],
                                            fileName: (note['file'] as String)
                                                .split('/')
                                                .last,
                                            lesson: lesson['name'],
                                            material: note,
                                            icon: FluentIcons
                                                .document_pdf_24_regular,
                                          );
                                        }).toList(), // Convert the iterable to a List<Widget>

                                        // Map slides to DesktopFile widgets and convert to list
                                        ...slides.map((slide) {
                                          return DesktopFile(
                                            slides: slides,
                                            notes: [],
                                            fileName: (slide['file'] as String)
                                                .split('/')
                                                .last,
                                            lesson: lesson['name'],
                                            material: slide,
                                            icon: FluentIcons
                                                .slide_layout_24_regular,
                                          );
                                        }).toList(), // Convert the iterable to a List<Widget>

                                        // Map recordings to DesktopRecording widgets and convert to list
                                        ...recordings.map((recording) {
                                          return DesktopRecording(
                                            recordings: recordings,
                                            contributions: [],
                                            fileName:
                                                (recording['file'] as String)
                                                    .split('/')
                                                    .last,
                                            lesson: lesson['name'],
                                            material: recording,
                                            icon: FluentIcons.play_24_filled,
                                          );
                                        }).toList(), // Convert the iterable to a List<Widget>

                                        // Map contributions to DesktopRecording widgets and convert to list
                                        ...contributions.map((contribution) {
                                          return DesktopRecording(
                                            contributions: contributions,
                                            recordings: [],
                                            fileName:
                                                (contribution['file'] as String)
                                                    .split('/')
                                                    .last,
                                            lesson: lesson['name'],
                                            material: contribution,
                                            icon: FluentIcons.play_24_filled,
                                          );
                                        }).toList(), // Convert the iterable to a List<Widget>
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<LessonsProvider>(
            builder: (context, lessonsProvider, _) {
          return Stack(
            children: [
              AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height:
                      context.watch<TogglesProvider>().showUploadTypeDropdown
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: AppUtils.$mainWhite,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Upload file",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppUtils.$mainBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: const Icon(FluentIcons.dismiss_24_regular),
                            ),
                          ],
                        ),
                        Gap(20),
                        GestureDetector(
                            onTap: pickFile,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppUtils.$mainBlack,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: AppUtils.$mainWhite,
                              ),
                              child: isUploading
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: AppUtils.$mainBlue,
                                      size: 40,
                                    )
                                  : Row(
                                      children: [
                                        Icon(Icons.upload_file_outlined),
                                        Gap(5),
                                        Text(selectedFileName ?? "Select file",
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                            )),
                        Gap(10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.notes),
                              labelText: 'File name',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212),
                                ),
                              ),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        Gap(10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'Description',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212),
                                ),
                              ),
                              focusColor: AppUtils.$mainBlue,
                            ),
                          ),
                        ),
                        Gap(10),
                        Consumer<TogglesProvider>(builder:
                            (BuildContext context, togglesProvider, _) {
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: TextField(
                                  controller: uploadTypeController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        FluentIcons.collections_24_regular),
                                    labelText: 'Select Upload type',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        togglesProvider
                                            .toggleUploadTypeDropDown();
                                      },
                                      icon: togglesProvider
                                              .showUploadTypeDropdown
                                          ? const Icon(
                                              FluentIcons.chevron_up_24_regular)
                                          : const Icon(FluentIcons
                                              .chevron_down_24_regular),
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 212, 212, 212),
                                      ),
                                    ),
                                    focusColor: AppUtils.$mainBlue,
                                  ),
                                ),
                              ),
                              Gap(10),
                              if (togglesProvider.showUploadTypeDropdown)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppUtils.$mainWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                            255, 229, 229, 229),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        uploadTypes.map<Widget>((uploadType) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            uploadTypeController.text =
                                                uploadType;
                                          });
                                          togglesProvider
                                              .toggleUploadTypeDropDown();
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              uploadType,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const Divider(
                                              color: Color.fromARGB(
                                                  255, 209, 209, 209),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          );
                        }),
                        Spacer(),
                        Consumer<UploadsProvider>(
                            builder: (context, uploadsProvider, child) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ElevatedButton(
                              onPressed: uploadsProvider.isLoading ||
                                      isUploading
                                  ? null
                                  : () {
                                      form = [
                                        nameController.text,
                                        unitIdRef,
                                        lessonIdRef,
                                        descriptionController.text,
                                        '7.30',
                                        uploadTypeController.text
                                      ];

                                      uploadsProvider.uploadNewFile(
                                          tokenRef,
                                          selectedFile!,
                                          form
                                              .toString()
                                              .replaceAll(']', '')
                                              .replaceAll('[', ''));

                                      if (uploadsProvider.success) {
                                        context
                                            .read<LessonsProvider>()
                                            .getLesson(tokenRef, lessonIdRef);
                                        Navigator.pop(context);
                                      }
                                    },
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                backgroundColor: WidgetStatePropertyAll(
                                  uploadsProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.$mainBlue,
                                ),
                                padding: WidgetStatePropertyAll(EdgeInsets.only(
                                    top: 20, bottom: 20, left: 10, right: 10)),
                              ),
                              child: uploadsProvider.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text('Upload',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppUtils.$mainWhite)),
                            ),
                          );
                        })
                      ]),
                ),
              ),
              if (context.watch<UploadsProvider>().success)
                Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<UploadsProvider>().message))
              else if (context.watch<UploadsProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<UploadsProvider>().message),
                )
            ],
          );
        });
      },
    );
  }
}
