import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_viewer/providers/lessons_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/responsive_nav.dart';
import 'package:note_viewer/widgets/notes_widgets/mobile_notes_item.dart';
import 'package:provider/provider.dart';

class MobileNotes extends StatefulWidget {
  final String tokenRef;
  final String unitId;

  const MobileNotes({super.key, required this.tokenRef, required this.unitId});

  @override
  State<MobileNotes> createState() => _MobileNotesState();
}

class _MobileNotesState extends State<MobileNotes> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController uploadTypeController = TextEditingController();

  Map selectedLesson = {};

  List uploadTypes = ['notes', 'slides', 'recordings'];

  @override
  Widget build(BuildContext context) {
    final lessons = context.watch<LessonsProvider>().lessons;
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      key: _scaffoldKey, // Attach the global key to the Scaffold
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppUtils.$mainBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.isNotEmpty && user['role'] == 'admin')
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding:
                              WidgetStatePropertyAll(const EdgeInsets.all(10)),
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                ],
              ),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(FluentIcons.search_24_regular),
                          filled: true,
                          fillColor: AppUtils.$mainWhite,
                          contentPadding: const EdgeInsets.all(5),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppUtils.$mainGrey),
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Search",
                          hintStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: context.watch<LessonsProvider>().isLoading
                    ? LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.$mainBlue, size: 100)
                    : ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (BuildContext context, int index) {
                          final lesson = lessons[index];

                          return MobileNotesItem(
                              lesson: lesson,
                              onPressed: (Map lesson) {
                                setState(() {
                                  selectedLesson = lesson;
                                });
                              });
                        }),
              ),
            ],
          ),
        ),
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
                  width: MediaQuery.of(context).size.width,
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
                                padding: const EdgeInsets.all(10),
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
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: lessonProvider.isLoading
                                      ? null
                                      : () {
                                          lessonProvider.createNewLesson(
                                              widget.tokenRef,
                                              nameController.text,
                                              widget.unitId);
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
                                            top: 10,
                                            bottom: 10,
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
