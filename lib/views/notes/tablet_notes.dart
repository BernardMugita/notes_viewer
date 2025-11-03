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
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:maktaba/widgets/notes_widgets/tablet_notes_item.dart';
import 'package:provider/provider.dart';

class TabletNotes extends StatefulWidget {
  final String tokenRef;
  final String unitId;

  const TabletNotes({super.key, required this.tokenRef, required this.unitId});

  @override
  State<TabletNotes> createState() => _TabletNotesState();
}

class _TabletNotesState extends State<TabletNotes> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Map selectedLesson = {};
  String tokenRef = '';
  String unitId = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    final toggleProvider = context.watch<TogglesProvider>();

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
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
      body: context.watch<LessonsProvider>().isLoading
          ? Center(
              child: Lottie.asset("assets/animations/maktaba_loader.json"),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      toggleProvider.searchAction(
                          searchController.text, lessons, 'name');
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppUtils.mainGrey(context).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppUtils.mainBlue(context),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppUtils.mainWhite(context),
                      prefixIcon: Icon(
                        FluentIcons.search_24_regular,
                        color: AppUtils.mainGrey(context).withOpacity(0.8),
                      ),
                      hintText: "Search lessons...",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        color: AppUtils.mainGrey(context).withOpacity(0.7),
                      ),
                    ),
                  ),
                  const Gap(20),

                  // Page Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (toggleProvider.searchMode)
                            Text(
                              toggleProvider.searchResults.isEmpty
                                  ? "No results found"
                                  : "Search results for '${searchController.text}'",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppUtils.mainGrey(context),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lessons',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppUtils.mainBlack(context),
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Study materials and resources',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppUtils.mainGrey(context),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (user.isNotEmpty &&
                          user['role'] == 'admin' &&
                          !toggleProvider.searchMode)
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
                          onPressed: () => _showDialog(context),
                          icon: const Icon(
                            FluentIcons.add_24_regular,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add Lesson",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Gap(20),

                  // Lessons List
                  Expanded(
                    child: lessons.isEmpty
                        ? Center(
                            child: EmptyWidget(
                              errorHeading: "No Lessons Found",
                              errorDescription:
                                  "No lessons have been uploaded for this unit yet.",
                              type: EmptyWidgetType.notes,
                            ),
                          )
                        : ListView.builder(
                            itemCount: toggleProvider.searchResults.isNotEmpty
                                ? toggleProvider.searchResults.length
                                : lessons.length,
                            itemBuilder: (BuildContext context, int index) {
                              final lesson = toggleProvider
                                      .searchResults.isNotEmpty
                                  ? toggleProvider.searchResults[index]
                                  : lessons[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TabletNotesItem(
                                  lesson: lesson,
                                  selectedLesson: selectedLesson,
                                  onPressed: (Map lesson) {
                                    setState(() {
                                      selectedLesson = lesson;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  content: Container(
                    padding: const EdgeInsets.all(28),
                    width: MediaQuery.of(context).size.width * 0.7,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add New Lesson",
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
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(FluentIcons.book_24_regular),
                              labelText: 'Lesson Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                ? 'Please enter a lesson name'
                                : null,
                          ),
                          const Gap(24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: lessonsProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await lessonsProvider
                                            .createNewLesson(tokenRef,
                                                nameController.text, unitId);
                                        if (success) {
                                          nameController.clear();
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
                                  lessonsProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                ),
                              ),
                              child: lessonsProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Add Lesson',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (context.watch<LessonsProvider>().success)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<LessonsProvider>().message),
                  )
                else if (context.watch<LessonsProvider>().error)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FailedWidget(
                        message: context.watch<LessonsProvider>().message),
                  )
              ],
            );
          },
        );
      },
    );
  }
}

