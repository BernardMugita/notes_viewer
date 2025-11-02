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
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:maktaba/widgets/notes_widgets/desktop_notes_item.dart';
import 'package:provider/provider.dart';

class DesktopNotes extends StatefulWidget {
  final String tokenRef;
  final String unitId;

  const DesktopNotes({super.key, required this.tokenRef, required this.unitId});

  @override
  State<DesktopNotes> createState() => _DesktopNotesState();
}

class _DesktopNotesState extends State<DesktopNotes> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Map selectedLesson = {};
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
    final toggleProvider = context.watch<TogglesProvider>();
    bool isMinimized = toggleProvider.isSideNavMinimized;

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: context.watch<LessonsProvider>().isLoading
          ? Center(
              child: Lottie.asset("assets/animations/maktaba_loader.json"),
            )
          : Flex(
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
                        top: 20,
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                        bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        // Top Bar
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppUtils.mainBlue(context),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: searchController,
                                  onChanged: (value) {
                                    toggleProvider.searchAction(
                                        searchController.text, lessons, 'name');
                                  },
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    filled: false,
                                    prefixIcon: Icon(
                                      FluentIcons.search_24_regular,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    hintText: "Search lessons...",
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          FluentIcons.alert_24_regular,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (context
                                          .watch<DashboardProvider>()
                                          .isNewActivities)
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
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => context.go('/settings'),
                                    icon: Icon(
                                      FluentIcons.settings_24_regular,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(12),
                                  Container(
                                    height: 32,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  Gap(12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    // mainAxisSize: MainAxisSize.AxisSize.min,
                                    children: [
                                      Text(
                                        user.isNotEmpty
                                            ? user['username']
                                            : 'Guest',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        user.isNotEmpty
                                            ? user['email']
                                            : 'guest@email.com',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(12),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      FluentIcons.person_24_regular,
                                      color: AppUtils.mainBlue(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lessons',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: AppUtils.mainBlack(context),
                                        ),
                                      ),
                                      Gap(4),
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
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppUtils.mainBlue(context)),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  elevation: WidgetStatePropertyAll(0),
                                ),
                                onPressed: () => _showDialog(context),
                                icon: Icon(
                                  FluentIcons.add_24_regular,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                label: Text(
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

                        // Lessons List
                        Expanded(
                          child: context.watch<LessonsProvider>().isLoading
                              ? Center(
                                  child: LoadingAnimationWidget.newtonCradle(
                                      color: AppUtils.mainBlue(context),
                                      size: 100),
                                )
                              : lessons.isEmpty
                                  ? Center(
                                      child: EmptyWidget(
                                        errorHeading: "No Lessons Found",
                                        errorDescription:
                                            "No lessons have been uploaded for this unit yet.",
                                        type: EmptyWidgetType.notes,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: toggleProvider
                                              .searchResults.isNotEmpty
                                          ? toggleProvider.searchResults.length
                                          : lessons.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final lesson = toggleProvider
                                                .searchResults.isNotEmpty
                                            ? toggleProvider
                                                .searchResults[index]
                                            : lessons[index];

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: DesktopNotesItem(
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
                ),
              ],
            ),
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
                  context.read<LessonsProvider>().lessons,
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
                hintText: "Search lessons...",
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
                    fontWeight: FontWeight.w600,
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
                                icon:
                                    const Icon(FluentIcons.dismiss_24_regular),
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
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  lessonsProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
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
                                  : Text(
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
