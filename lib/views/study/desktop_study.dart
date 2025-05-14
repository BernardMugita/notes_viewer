import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:maktaba/widgets/study_widgets/desktop_file.dart';
import 'package:maktaba/widgets/study_widgets/desktop_recording.dart';
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
  TextEditingController searchController = TextEditingController();

  List uploadTypes = ['notes', 'slides', 'recordings'];
  List allMaterial = [];
  List<String> form = [];

  // Removed notes, slides, recordings, contributions, and isMaterialsEmpty from state.
  // They will be computed directly in build.

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
      setState(() {
        isUploading = false;
      });
    }
  }

  void _populateAllMaterial() {
    final lesson = context.read<LessonsProvider>().lesson;
    final materials = (lesson['materials'] as Map<String, dynamic>?) ?? {};

    final notes = (materials['notes'] as List?) ?? [];
    final slides = (materials['slides'] as List?) ?? [];
    final recordings = (materials['recordings'] as List?) ?? [];
    final contributions = (materials['contributions'] as List?) ?? [];

    allMaterial = [
      ...notes.cast<Map<String, dynamic>>(),
      ...slides.cast<Map<String, dynamic>>(),
      ...recordings.cast<Map<String, dynamic>>(),
      ...contributions.cast<Map<String, dynamic>>(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _populateAllMaterial();
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

      if (lessonId != null && lessonId.isNotEmpty) {
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    _populateAllMaterial();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsProvider = context.watch<LessonsProvider>();
    final lesson = lessonsProvider.lesson;
    final user = context.watch<UserProvider>().user;
    final isAdmin = user['role'] == 'admin';
    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

    bool isMaterialsEmpty = !lessonsProvider.isLoading && allMaterial.isEmpty;

    final children = [
      for (int i = 0; i < allMaterial.length; i++)
        _buildMaterialItem(allMaterial[i], i),
    ];

    return Consumer2<LessonsProvider, TogglesProvider>(
      builder: (BuildContext context, lessonsProvider, toggleProvider, _) {
        return Scaffold(
          backgroundColor: AppUtils.backgroundPanel(context),
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
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1,
                      top: 20,
                      bottom: 20),
                  child: lessonsProvider.isLoading
                      ? LoadingAnimationWidget.newtonCradle(
                          color: AppUtils.mainBlue(context), size: 100)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppUtils.mainBlue(context),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        toggleProvider.searchAction(
                                            searchController.text,
                                            allMaterial,
                                            'name');
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12.5),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppUtils.mainWhite(context),
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppUtils.mainWhite(context),
                                            width: 2,
                                          ),
                                        ),
                                        filled: false,
                                        prefixIcon: Icon(
                                          FluentIcons.search_24_regular,
                                          color: AppUtils.mainWhite(context)
                                              .withOpacity(0.8),
                                        ),
                                        hintText: "Search",
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.mainWhite(context)
                                                .withOpacity(0.8)),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Icon(
                                            FluentIcons.alert_24_regular,
                                            size: 25,
                                            color: AppUtils.mainWhite(context),
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: CircleAvatar(
                                                radius: 5,
                                                backgroundColor: context
                                                        .watch<
                                                            DashboardProvider>()
                                                        .isNewActivities
                                                    ? AppUtils.mainRed(context)
                                                    : AppUtils.mainGrey(
                                                        context),
                                              ))
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            context.go('/settings');
                                          },
                                          icon: Icon(
                                            FluentIcons.settings_24_regular,
                                            size: 25,
                                            color: AppUtils.mainWhite(context),
                                          )),
                                      Gap(10),
                                      SizedBox(
                                        height: 40,
                                        child: VerticalDivider(
                                          color: AppUtils.mainGrey(context),
                                        ),
                                      ),
                                      Gap(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          if (context
                                              .watch<UserProvider>()
                                              .isLoading)
                                            SizedBox(
                                              width: 150,
                                              child: LinearProgressIndicator(
                                                minHeight: 1,
                                                color:
                                                    AppUtils.mainWhite(context),
                                              ),
                                            )
                                          else
                                            Text(
                                                user.isNotEmpty
                                                    ? user['username']
                                                    : 'Guest',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppUtils.mainWhite(
                                                        context),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          if (context
                                              .watch<UserProvider>()
                                              .isLoading)
                                            SizedBox(
                                              width: 50,
                                              child: LinearProgressIndicator(
                                                minHeight: 1,
                                                color:
                                                    AppUtils.mainWhite(context),
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                  user.isNotEmpty
                                                      ? user['email']
                                                      : 'guest@email.com',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 12,
                                                      color: AppUtils.mainWhite(
                                                          context))),
                                            ),
                                        ],
                                      ),
                                      Gap(10),
                                      CircleAvatar(
                                        child:
                                            Icon(FluentIcons.person_24_regular),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Gap(20),
                            if (!toggleProvider.searchMode)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Units/Notes/${lesson['name']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainGrey(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    lesson['name'] ?? "Lesson name",
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: AppUtils.mainBlue(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user.isNotEmpty &&
                                    user['role'] == 'admin' &&
                                    !toggleProvider.searchMode)
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        padding: WidgetStatePropertyAll(
                                            const EdgeInsets.all(20)),
                                        backgroundColor: WidgetStatePropertyAll(
                                            AppUtils.mainBlue(context)),
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
                                              color:
                                                  AppUtils.mainWhite(context),
                                            ),
                                          ),
                                          const Gap(5),
                                          Icon(
                                            FluentIcons.book_add_24_regular,
                                            size: 16,
                                            color: AppUtils.mainWhite(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const Gap(20),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        !toggleProvider.searchMode
                                            ? "Study material"
                                            : "Search results for '${searchController.text}'",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppUtils.mainGrey(context),
                                            fontWeight: FontWeight.bold)),
                                    const Gap(20),
                                    if (isMaterialsEmpty)
                                      Expanded(
                                        child: Center(
                                          child: EmptyWidget(
                                              errorHeading: "How Empty!",
                                              errorDescription:
                                                  "There's no study material for this lesson",
                                              image: context
                                                      .watch<ThemeProvider>()
                                                      .isDarkMode
                                                  ? 'assets/images/404-dark.png'
                                                  : 'assets/images/404.png'),
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        height: isAdmin
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.65
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.7,
                                        child: isAdmin
                                            ? ReorderableListView(
                                                clipBehavior: Clip.none,
                                                onReorder:
                                                    (oldIndex, newIndex) {
                                                  setState(() {
                                                    if (newIndex > oldIndex) {
                                                      newIndex -= 1;
                                                    }
                                                    final item = allMaterial
                                                        .removeAt(oldIndex);
                                                    allMaterial.insert(
                                                        newIndex, item);
                                                  });
                                                },
                                                children: [
                                                  for (int i = 0;
                                                      i < allMaterial.length;
                                                      i++)
                                                    _buildMaterialItem(
                                                        allMaterial[i], i),
                                                ],
                                              )
                                            : ListView(
                                                children: children,
                                              ),
                                      ),
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
      },
    );
  }

  Widget _buildMaterialItem(Map<String, dynamic> mat, int index) {
    final type = mat['type'] as String;
    final file = (mat['file'] as String).split('/').last;
    final icon = _iconForType(type);

    if (type == 'notes' || type == 'slides') {
      return DesktopFile(
        key: ValueKey(mat['id'] ?? index),
        notes: type == 'notes' ? allMaterial : [],
        slides: type == 'slides' ? allMaterial : [],
        fileName: file,
        lesson: context.read<LessonsProvider>().lesson['name'] as String,
        material: mat,
        icon: icon,
      );
    } else {
      return DesktopRecording(
        key: ValueKey(mat['id'] ?? index),
        recordings: type == 'recordings' ? allMaterial : [],
        contributions: type == 'contributions' ? allMaterial : [],
        fileName: file,
        lesson: context.read<LessonsProvider>().lesson['name'] as String,
        material: mat,
        icon: icon,
      );
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'notes':
        return FluentIcons.document_pdf_24_regular;
      case 'slides':
        return FluentIcons.slide_layout_24_regular;
      case 'recordings':
        return FluentIcons.play_24_filled;
      case 'contributions':
        return FluentIcons.person_24_regular;
      default:
        return FluentIcons.question_24_regular;
    }
  }

  void _showDialog(BuildContext context) {
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
                                icon:
                                    const Icon(FluentIcons.dismiss_24_regular),
                              ),
                            ],
                          ),
                          const Gap(20),
                          GestureDetector(
                            onTap: pickFile,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10, bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.25,
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
                                        const Gap(5),
                                        Text(selectedFileName ?? "Select file",
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                      ],
                                    ),
                            ),
                          ),
                          const Gap(10),
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
                                focusColor: AppUtils.mainBlue(context),
                              ),
                            ),
                          ),
                          const Gap(10),
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
                                focusColor: AppUtils.mainBlue(context),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Consumer<TogglesProvider>(builder:
                              (BuildContext context, togglesProvider, _) {
                            return Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                            ? const Icon(FluentIcons
                                                .chevron_up_24_regular)
                                            : const Icon(FluentIcons
                                                .chevron_down_24_regular),
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      focusColor: AppUtils.mainBlue(context),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                if (togglesProvider.showUploadTypeDropdown)
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
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
                                                style: const TextStyle(
                                                    fontSize: 16),
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
                          const Spacer(),
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
                                        : AppUtils.mainBlue(context),
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    const EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 10,
                                        right: 10),
                                  ),
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
                                    : Text('Upload',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                AppUtils.mainWhite(context))),
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
          },
        );
      },
    );
  }
}
