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
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/study_widgets/mobile_file.dart';
import 'package:maktaba/widgets/study_widgets/mobile_recording.dart';
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
  bool sortMode = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController uploadTypeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List uploadTypes = ['notes', 'slides', 'recordings'];
  List allMaterial = [];
  List originalMaterialList = [];

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
      final userProvider = context.read<UserProvider>();

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
        userProvider.fetchUserDetails(token);
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

    bool isMaterialsEmpty = !lessonsProvider.isLoading && allMaterial.isEmpty;

    final children = [
      for (int i = 0; i < allMaterial.length; i++)
        _buildMaterialItem(allMaterial[i], i),
    ];

    return Consumer2<LessonsProvider, TogglesProvider>(
      builder: (BuildContext context, lessonsProvider, toggleProvider, _) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppUtils.mainBlue(context),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                FluentIcons.re_order_dots_vertical_24_regular,
                color: Colors.white,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.alert_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
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
              const Gap(12),
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
              const Gap(16),
            ],
          ),
          drawer: const ResponsiveNav(),
          backgroundColor: AppUtils.backgroundPanel(context),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: lessonsProvider.isLoading
                    ? Center(
                        child: Lottie.asset(
                            "assets/animations/maktaba_loader.json"),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!toggleProvider.searchMode)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                          const Gap(20),
                          if (user.isNotEmpty &&
                              user['role'] == 'admin' &&
                              !toggleProvider.searchMode)
                            Row(
                              children: [
                                if (!sortMode)
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 14),
                                      ),
                                      backgroundColor: WidgetStateProperty.all(
                                          AppUtils.mainBlue(context)),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      elevation: WidgetStateProperty.all(0),
                                    ),
                                    onPressed: () {
                                      _showDialog(context);
                                    },
                                    icon: const Icon(
                                      FluentIcons.book_add_24_regular,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
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
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 14),
                                      ),
                                      backgroundColor: WidgetStateProperty.all(
                                          AppUtils.mainRed(context)),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      elevation: WidgetStateProperty.all(0),
                                    ),
                                    onPressed: resetToDefault,
                                    icon: const Icon(
                                      FluentIcons.arrow_reset_24_regular,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Reset",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Gap(12),
                                  ElevatedButton.icon(
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 14),
                                      ),
                                      backgroundColor: WidgetStateProperty.all(
                                          AppUtils.mainGreen(context)),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      elevation: WidgetStateProperty.all(0),
                                    ),
                                    onPressed:
                                        lessonsProvider.isSortLoading ? null : addSort,
                                    icon: lessonsProvider.isSortLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            FluentIcons.save_24_regular,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                    label: const Text(
                                      "Save",
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
                          const Gap(20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            onReorder: (oldIndex, newIndex) {
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
              if (context.watch<LessonsProvider>().sortSuccess)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SuccessWidget(
                      message: context.watch<LessonsProvider>().sortMessage),
                )
              else if (context.watch<LessonsProvider>().sortError)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<LessonsProvider>().sortMessage),
                )
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
      return MobileFile(
        key: ValueKey(index),
        notes: type == 'notes' ? allMaterial : [],
        slides: type == 'slides' ? allMaterial : [],
        fileName: file,
        lesson: context.read<LessonsProvider>().lesson['name'] as String,
        material: mat,
        icon: icon,
      );
    } else {
      return MobileRecording(
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

  void _showDialog(
    BuildContext context,
  ) {
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
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: const BoxConstraints(maxWidth: 600),
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
                                icon: const Icon(
                                    FluentIcons.dismiss_24_regular),
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
                              prefixIcon: const Icon(
                                  FluentIcons.document_24_regular),
                              labelText: 'File name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
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
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a file name' : null,
                          ),
                          const Gap(16),

                          // Description
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Icon(FluentIcons.text_32_regular),
                              ),
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
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
                            builder: (BuildContext context, togglesProvider, _) {
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
                                        borderSide: const BorderSide(
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
                                      margin: const EdgeInsets.only(top: 8),
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
                                            color: Colors.black
                                                .withOpacity(0.1),
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
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: uploadTypeController
                                                            .text ==
                                                        uploadType
                                                    ? AppUtils.mainBlue(
                                                            context)
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
                                              'type':
                                                  uploadTypeController.text
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
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                      uploadsProvider.isLoading
                                          ? Colors.grey
                                          : AppUtils.mainBlue(context),
                                    ),
                                    padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
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
                                      : const Text(
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
