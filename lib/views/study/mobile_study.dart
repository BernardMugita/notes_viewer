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
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/study_widgets/mobile_file.dart';
import 'package:note_viewer/widgets/study_widgets/mobile_recording.dart';
import 'package:provider/provider.dart';

class MobileStudy extends StatefulWidget {
  const MobileStudy({super.key});

  @override
  State<MobileStudy> createState() => _MobileStudyState();
}

class _MobileStudyState extends State<MobileStudy> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    List notes = [];
    List slides = [];
    List recordings = [];
    List contributions = [];

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

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(FluentIcons.re_order_24_regular),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  const Gap(5),
                  Text(
                    lesson['name'] ?? "Lesson Name",
                    style: TextStyle(
                      fontSize: 24,
                      color: AppUtils.mainBlue(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.isNotEmpty && user['role'] == 'admin')
                    ElevatedButton(
                      style: ButtonStyle(
                        padding:
                            WidgetStatePropertyAll(const EdgeInsets.all(20)),
                        backgroundColor:
                            WidgetStatePropertyAll(AppUtils.mainBlue(context)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: Icon(
                        FluentIcons.book_add_24_regular,
                        size: 16,
                        color: AppUtils.mainWhite(context),
                      ),
                    ),
                ],
              ),
              const Gap(20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Study material",
                          style:
                              TextStyle(fontSize: 18, color: AppUtils.mainGrey(context))),
                      const Gap(20),
                      if (lesson.isEmpty &&
                          notes.isEmpty &&
                          slides.isEmpty &&
                          recordings.isEmpty &&
                          contributions.isEmpty)
                        Expanded(
                            child: Center(
                          child: Container(
                            width: 400,
                            height: 400,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppUtils.mainBlueAccent(context),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.prohibited_24_regular,
                                  size: 100,
                                  color: Colors.orange,
                                ),
                                Gap(20),
                                Text("How Empty!",
                                    style: TextStyle(fontSize: 20)),
                                Gap(10),
                                Text(
                                  "There's no study material for this lesson",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ))
                      else
                        Column(
                          spacing: 5,
                          children: [
                            ...notes.map((note) {
                              return MobileFile(
                                notes: notes,
                                slides: [],
                                fileName:
                                    (note['file'] as String).split('/').last,
                                lesson: lesson['name'],
                                material: note,
                                icon: FluentIcons.document_pdf_24_regular,
                              );
                            }),
                            ...slides.map((slide) {
                              return MobileFile(
                                slides: slides,
                                notes: [],
                                fileName:
                                    (slide['file'] as String).split('/').last,
                                lesson: lesson['name'],
                                material: slide,
                                icon: FluentIcons.slide_layout_24_regular,
                              );
                            }),
                            ...recordings.map((recording) {
                              return MobileRecording(
                                recordings: recordings,
                                contributions: [],
                                fileName:
                                    (recording['file'] as String).split('/').last,
                                lesson: lesson['name'],
                                material: recording,
                                icon: FluentIcons.play_24_filled,
                              );
                            }),
                            ...contributions.map((contribution) {
                              return MobileRecording(
                                recordings: [],
                                contributions: contributions,
                                fileName: (contribution['file'] as String)
                                    .split('/')
                                    .last,
                                lesson: lesson['name'],
                                material: contribution,
                                icon: FluentIcons.play_24_filled,
                              );
                            }),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ])));
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
                  width: MediaQuery.of(context).size.width,
                  height:
                      context.watch<TogglesProvider>().showUploadTypeDropdown
                          ? MediaQuery.of(context).size.height * 0.75
                          : MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
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
                                color: AppUtils.mainBlue(context),
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
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppUtils.mainBlack(context),
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: AppUtils.mainWhite(context),
                              ),
                              child: isUploading
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: AppUtils.mainBlue(context),
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
                              focusColor: AppUtils.mainBlue(context),
                            ),
                          ),
                        ),
                        Gap(10),
                        SizedBox(
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
                              focusColor: AppUtils.mainBlue(context),
                            ),
                          ),
                        ),
                        Gap(10),
                        Consumer<TogglesProvider>(builder:
                            (BuildContext context, togglesProvider, _) {
                          return Column(
                            children: [
                              SizedBox(
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
                                    focusColor: AppUtils.mainBlue(context),
                                  ),
                                ),
                              ),
                              Gap(10),
                              if (togglesProvider.showUploadTypeDropdown)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppUtils.mainWhite(context),
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
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: uploadsProvider.isLoading
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
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: WidgetStatePropertyAll(EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10)),
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
                                  :  Text('Upload',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppUtils.mainWhite(context))),
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
