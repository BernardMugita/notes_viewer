import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
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
  bool sortMode = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController uploadTypeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List uploadTypes = ['notes', 'slides', 'recordings'];
  List allMaterial = [];
  List originalMaterialList = [];
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
      setState(() {
        isUploading = false;
      });
    }
  }

  void _populateAllMaterial() {
    final lesson = context.read<LessonsProvider>().lesson;
    final materials = (lesson['materials'] as List<dynamic>?) ?? [];

    setState(() {
      allMaterial = List.from(materials);
      originalMaterialList = List.from(materials);
    });
  }

  void addSort() async {
    try {
      final lessonProvider = context.read<LessonsProvider>();

      await lessonProvider.updateLessonSort(
        tokenRef,
        lessonProvider.lesson['id'],
        allMaterial,
      );

      await lessonProvider.getLesson(tokenRef, lessonProvider.lesson['id']);

      setState(() {
        _populateAllMaterial();
        sortMode = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void resetToDefault() {
    setState(() {
      allMaterial = List.from(originalMaterialList);
      sortMode = false;
    });
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
        return lessonsProvider.isLoading
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Lottie.asset("assets/animations/maktaba_loader.json"),
              )
            : Scaffold(
                backgroundColor: AppUtils.backgroundPanel(context),
                body: Stack(
                  children: [
                    Flex(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 20,
                              children: [
                                _buildTopBar(
                                    context,
                                    toggleProvider,
                                    user,
                                    context
                                        .watch<DashboardProvider>()
                                        .isNewActivities),

                                // Page Header
                                if (!toggleProvider.searchMode)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Units/Notes/${lesson['name']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppUtils.mainGrey(context),
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        lesson['name'] ?? "Lesson name",
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: AppUtils.mainBlack(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                // Action Buttons
                                if (user.isNotEmpty &&
                                    user['role'] == 'admin' &&
                                    !toggleProvider.searchMode)
                                  Row(
                                    spacing: 12,
                                    children: [
                                      if (!sortMode)
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                            padding: WidgetStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 16),
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppUtils.mainBlue(context)),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            elevation:
                                                WidgetStatePropertyAll(0),
                                          ),
                                          onPressed: () {
                                            _showDialog(context);
                                          },
                                          icon: Icon(
                                            FluentIcons.book_add_24_regular,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Upload file",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      else ...[
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                            padding: WidgetStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 16),
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppUtils.mainRed(context)),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            elevation:
                                                WidgetStatePropertyAll(0),
                                          ),
                                          onPressed: resetToDefault,
                                          icon: Icon(
                                            FluentIcons.arrow_reset_24_regular,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            "Reset to default",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          style: ButtonStyle(
                                            padding: WidgetStatePropertyAll(
                                              EdgeInsets.symmetric(
                                                  horizontal: 24, vertical: 16),
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppUtils.mainGreen(
                                                        context)),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            elevation:
                                                WidgetStatePropertyAll(0),
                                          ),
                                          onPressed:
                                              lessonsProvider.isSortLoading
                                                  ? null
                                                  : addSort,
                                          icon: lessonsProvider.isSortLoading
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Icon(
                                                  FluentIcons.save_24_regular,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                          label: Text(
                                            "Save Changes",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),

                                // Materials Section
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        !toggleProvider.searchMode
                                            ? "Study material"
                                            : "Search results for '${searchController.text}'",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppUtils.mainBlack(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(16),
                                      if (isMaterialsEmpty)
                                        Expanded(
                                          child: Center(
                                            child: EmptyWidget(
                                              errorHeading: "How Empty!",
                                              errorDescription:
                                                  "There's no study material for this lesson",
                                              type: EmptyWidgetType.notes,
                                            ),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: isAdmin
                                              ? ReorderableListView(
                                                  clipBehavior: Clip.none,
                                                  onReorder:
                                                      (oldIndex, newIndex) {
                                                    setState(() {
                                                      sortMode = true;
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (context.watch<LessonsProvider>().sortSuccess)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: SuccessWidget(
                            message:
                                context.watch<LessonsProvider>().sortMessage),
                      )
                    else if (context.watch<LessonsProvider>().sortError)
                      Positioned(
                        top: 20,
                        right: 20,
                        child: FailedWidget(
                            message:
                                context.watch<LessonsProvider>().sortMessage),
                      )
                  ],
                ),
              );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, TogglesProvider togglesProvider,
      Map<dynamic, dynamic> user, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
              onChanged: (value) {
                togglesProvider.searchAction(
                  searchController.text,
                  allMaterial,
                  'name',
                );
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppUtils.mainWhite(context).withOpacity(0.1),
                prefixIcon: Icon(
                  FluentIcons.search_24_regular,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search materials...",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.alert_24_regular,
                      size: 24,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                  if (isNewActivities)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppUtils.mainRed(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(8),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  user.isNotEmpty ? user['username'][0].toUpperCase() : 'G',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialItem(Map<String, dynamic> mat, int index) {
    final type = mat['type'] as String;
    final file = (mat['file'] as String).split('/').last;
    final icon = _iconForType(type);

    if (type == 'notes' || type == 'slides') {
      return DesktopFile(
        key: ValueKey(index),
        notes: type == 'notes' ? allMaterial : [],
        slides: type == 'slides' ? allMaterial : [],
        fileName: file,
        lesson: context.read<LessonsProvider>().lesson['name'] as String,
        material: mat,
        icon: icon,
      );
    } else {
      return DesktopRecording(
        key: ValueKey(index),
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
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<LessonsProvider>(
          builder: (context, lessonsProvider, _) {
            return Stack(
              children: [
                AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(28),
                    width: MediaQuery.of(context).size.width * 0.35,
                    constraints: BoxConstraints(maxWidth: 600),
                    decoration: BoxDecoration(
                      color: AppUtils.mainWhite(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Upload New File",
                                style: TextStyle(
                                  fontSize: 22,
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
                          const Gap(24),

                          // File Picker
                          InkWell(
                            onTap: pickFile,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppUtils.mainGrey(context)
                                      .withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade50,
                              ),
                              child: isUploading
                                  ? Center(
                                      child: LoadingAnimationWidget
                                          .staggeredDotsWave(
                                        color: AppUtils.mainBlue(context),
                                        size: 40,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppUtils.mainBlue(context)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            FluentIcons.arrow_upload_24_regular,
                                            color: AppUtils.mainBlue(context),
                                          ),
                                        ),
                                        const Gap(12),
                                        Expanded(
                                          child: Text(
                                            selectedFileName ??
                                                "Click to select file",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: selectedFileName != null
                                                  ? AppUtils.mainBlack(context)
                                                  : AppUtils.mainGrey(context),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const Gap(16),

                          // File Name
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.document_24_regular),
                              labelText: 'File name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppUtils.mainBlue(context),
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a file name'
                                : null,
                          ),
                          const Gap(16),

                          // Description
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Icon(FluentIcons.text_32_regular),
                              ),
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppUtils.mainBlue(context),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const Gap(16),

                          // Upload Type Dropdown
                          Consumer<TogglesProvider>(
                            builder:
                                (BuildContext context, togglesProvider, _) {
                              return Column(
                                children: [
                                  TextFormField(
                                    controller: uploadTypeController,
                                    readOnly: true,
                                    onTap: () {
                                      togglesProvider
                                          .toggleUploadTypeDropDown();
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          FluentIcons.collections_24_regular),
                                      labelText: 'Upload type',
                                      suffixIcon: Icon(
                                        togglesProvider.showUploadTypeDropdown
                                            ? FluentIcons.chevron_up_24_regular
                                            : FluentIcons
                                                .chevron_down_24_regular,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppUtils.mainBlue(context),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? 'Please select upload type'
                                        : null,
                                  ),
                                  if (togglesProvider.showUploadTypeDropdown)
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppUtils.mainWhite(context),
                                        border: Border.all(
                                          color: AppUtils.mainGrey(context)
                                              .withOpacity(0.3),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: uploadTypes
                                            .map<Widget>((uploadType) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                uploadTypeController.text =
                                                    uploadType;
                                              });
                                              togglesProvider
                                                  .toggleUploadTypeDropDown();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: uploadTypeController
                                                            .text ==
                                                        uploadType
                                                    ? AppUtils.mainBlue(context)
                                                        .withOpacity(0.1)
                                                    : Colors.transparent,
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    uploadType
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          uploadTypeController
                                                                      .text ==
                                                                  uploadType
                                                              ? AppUtils
                                                                  .mainBlue(
                                                                      context)
                                                              : AppUtils
                                                                  .mainBlack(
                                                                      context),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const Gap(24),

                          // Submit Button
                          Consumer<UploadsProvider>(
                            builder: (context, uploadsProvider, child) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: uploadsProvider.isLoading ||
                                          isUploading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final Map<String, String> form = {
                                              'name': nameController.text,
                                              'unit_id': unitIdRef,
                                              'lesson_id': lessonIdRef,
                                              'description':
                                                  descriptionController.text,
                                              'duration': '7.30',
                                              'type': uploadTypeController.text
                                            };

                                            final success =
                                                await uploadsProvider
                                                    .uploadNewFile(tokenRef,
                                                        selectedFile!, form);

                                            if (success) {
                                              context
                                                  .read<LessonsProvider>()
                                                  .getLesson(
                                                      tokenRef, lessonIdRef);
                                              Navigator.of(dialogContext).pop();
                                            }
                                          }
                                        },
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      uploadsProvider.isLoading
                                          ? Colors.grey
                                          : AppUtils.mainBlue(context),
                                    ),
                                    padding: const WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 24),
                                    ),
                                  ),
                                  child: uploadsProvider.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          'Upload',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (context.watch<UploadsProvider>().success)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<UploadsProvider>().message),
                  )
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
