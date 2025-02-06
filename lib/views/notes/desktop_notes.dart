import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/units_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_empty_overview.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_notes_item.dart';
import 'package:note_viewer/widgets/notes_widgets/desktop_notes_overview.dart';
import 'package:provider/provider.dart';

class DesktopNotes extends StatefulWidget {
  final String tokenRef;
  final String unitId;

  const DesktopNotes({super.key, required this.tokenRef, required this.unitId});

  @override
  State<DesktopNotes> createState() => _DesktopNotesState();
}

class _DesktopNotesState extends State<DesktopNotes> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController uploadTypeController = TextEditingController();

  Map selectedLesson = {};

  List uploadTypes = ['notes', 'slides', 'recordings'];

  String tokenRef = '';
  String unitId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<UserProvider>().fetchUserDetails(token);
        setState(() {
          unitId = context.read<UnitsProvider>().unitId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessons = context.watch<LessonsProvider>().lessons;
    final user = context.watch<UserProvider>().user;

    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        FluentIcons.book_24_regular,
                        color: AppUtils.$mainBlue,
                      ),
                      const Gap(5),
                      Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 30,
                          color: AppUtils.$mainBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (user.isNotEmpty && user['role'] == 'admin')
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                                const EdgeInsets.all(20)),
                            backgroundColor:
                                WidgetStatePropertyAll(AppUtils.$mainBlue),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _showDialog(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                "Add Lesson",
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
                    ],
                  ),
                  const Gap(10),
                  const Divider(
                    color: Color(0xFFCECECE),
                  ),
                  const Gap(20),
                  Expanded(
                    // This ensures the scrolling area takes the remaining height
                    child: SizedBox(
                      width: double.infinity,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              child: context.watch<LessonsProvider>().isLoading
                                  ? LoadingAnimationWidget.newtonCradle(
                                      color: AppUtils.$mainBlue, size: 100)
                                  : ListView.builder(
                                      itemCount: lessons.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final lesson = lessons[index];

                                        return DesktopNotesItem(
                                            lesson: lesson,
                                            onPressed: (Map lesson) {
                                              setState(() {
                                                selectedLesson = lesson;
                                              });
                                              print(selectedLesson);
                                            });
                                      }),
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: 1,
                            height: MediaQuery.of(context).size.height / 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppUtils.$mainGrey,
                              ),
                            ),
                          ),
                          const Gap(20),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                if (context
                                        .watch<TogglesProvider>()
                                        .isLessonSelected &&
                                    selectedLesson.isNotEmpty)
                                  DesktopNotesOverview(
                                    lesson: selectedLesson,
                                  )
                                else
                                  DesktopEmptyOverview()
                              ],
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
                          ? MediaQuery.of(context).size.height * 0.6
                          : MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    color: AppUtils.$mainWhite,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: context
                            .watch<TogglesProvider>()
                            .showUploadTypeDropdown
                        ? [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add New Lesson",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppUtils.$mainBlue,
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
                            Gap(20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(FluentIcons.book_24_regular),
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
                            Gap(20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                controller: nameController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(FluentIcons.book_24_regular),
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
                            Gap(20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(FluentIcons.book_24_regular),
                                  labelText: 'Select Upload type',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .watch<TogglesProvider>()
                                          .toggleUploadTypeDropDown();
                                    },
                                    icon: context
                                            .watch<TogglesProvider>()
                                            .showUploadTypeDropdown
                                        ? const Icon(
                                            FluentIcons.chevron_up_24_regular)
                                        : const Icon(FluentIcons
                                            .chevron_down_24_regular),
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 212, 212, 212),
                                    ),
                                  ),
                                  focusColor: AppUtils.$mainBlue,
                                ),
                              ),
                            ),
                            if (context
                                .watch<TogglesProvider>()
                                .showUploadTypeDropdown)
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width * 0.25,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      uploadTypes.map<Widget>((uploadType) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          uploadTypeController.text =
                                              uploadType;
                                        });
                                        context
                                            .watch<TogglesProvider>()
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
                              )
                          ]
                        : [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add New Lesson",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppUtils.$mainBlue,
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
                            Gap(20),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          FluentIcons.book_24_regular),
                                      labelText: 'Lesson name',
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 212, 212, 212),
                                        ),
                                      ),
                                      focusColor: AppUtils.$mainBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Consumer<LessonsProvider>(
                                builder: (context, lessonProvider, child) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  onPressed: lessonProvider.isLoading
                                      ? null
                                      : () {
                                          lessonProvider.createNewLesson(
                                              tokenRef,
                                              nameController.text,
                                              unitId);
                                          if (lessonProvider.success) {
                                            lessonProvider.getAllLesson(
                                                widget.tokenRef, widget.unitId);
                                            Navigator.pop(context);
                                          }
                                        },
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    backgroundColor: WidgetStatePropertyAll(
                                      lessonProvider.isLoading
                                          ? Colors.grey
                                          : AppUtils.$mainBlue,
                                    ),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 10,
                                            right: 10)),
                                  ),
                                  child: lessonProvider.isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text('Add Lesson',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppUtils.$mainWhite)),
                                ),
                              );
                            })
                          ],
                  ),
                ),
              ),
              if (context.watch<LessonsProvider>().success)
                Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<LessonsProvider>().message))
              else if (context.watch<LessonsProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<LessonsProvider>().message),
                )
            ],
          );
        });
      },
    );
  }
}
