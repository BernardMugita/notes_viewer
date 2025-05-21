import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/notes_widgets/mobile_notes_item.dart';
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
  TextEditingController searchController = TextEditingController();

  Map selectedLesson = {};

  List uploadTypes = ['notes', 'slides', 'recordings'];

  @override
  Widget build(BuildContext context) {
    final lessons = context.watch<LessonsProvider>().lessons;
    final user = context.watch<UserProvider>().user;

    final toggleProvider = context.watch<TogglesProvider>();

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppUtils.mainBlue(context),
        elevation: 3,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            FluentIcons.re_order_24_regular,
            color: AppUtils.mainWhite(context),
          ),
        ),
      ),
      drawer: const ResponsiveNav(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              toggleProvider.searchAction(
                                  searchController.text, lessons, 'name');
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(12.5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppUtils.mainGrey(context),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppUtils.mainGrey(context),
                                  width: 2,
                                ),
                              ),
                              filled: false,
                              prefixIcon: Icon(
                                FluentIcons.search_24_regular,
                                color:
                                    AppUtils.mainGrey(context).withOpacity(0.8),
                              ),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppUtils.mainGrey(context)
                                      .withOpacity(0.8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (user.isNotEmpty && user['role'] == 'admin')
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding:
                              WidgetStatePropertyAll(const EdgeInsets.all(10)),
                          backgroundColor: WidgetStatePropertyAll(
                              AppUtils.mainBlue(context)),
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
                                color: AppUtils.mainWhite(context),
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
              if (toggleProvider.searchMode)
                SizedBox(
                  width: double.infinity,
                  child: Text(toggleProvider.searchResults.isEmpty
                      ? "No results found for '${searchController.text}'"
                      : "Search results for '${searchController.text}'"),
                ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: context.watch<LessonsProvider>().isLoading
                    ? LoadingAnimationWidget.newtonCradle(
                        color: AppUtils.mainBlue(context), size: 100)
                    : ListView.builder(
                        itemCount: toggleProvider.searchResults.isNotEmpty
                            ? toggleProvider.searchResults.length
                            : lessons.length,
                        itemBuilder: (BuildContext context, int index) {
                          final lesson = toggleProvider.searchResults.isNotEmpty
                              ? toggleProvider.searchResults[index]
                              : lessons[index];

                          return MobileNotesItem(
                              lesson: lesson,
                              selectedLesson: selectedLesson,
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
                    color: AppUtils.mainWhite(context),
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
                                  focusColor: AppUtils.mainBlue(context),
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
                                  focusColor: AppUtils.mainBlue(context),
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
                                  focusColor: AppUtils.mainBlue(context),
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
                                      focusColor: AppUtils.mainBlue(context),
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
                                          : AppUtils.mainBlue(context),
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
                                      : Text('Add Lesson',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  AppUtils.mainWhite(context))),
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
