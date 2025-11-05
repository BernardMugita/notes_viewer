import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopAccount extends StatefulWidget {
  const DesktopAccount({super.key});

  @override
  State<DesktopAccount> createState() => _DesktopAccountState();
}

class _DesktopAccountState extends State<DesktopAccount> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController regNoController = TextEditingController();

  Map user = {};
  Map course = {};
  String tokenRef = '';
  String selectedTab = 'account'; // 'account' or 'membership'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<UserProvider>().fetchUserDetails(token);
        user = context.read<UserProvider>().user;
        context
            .read<CoursesProvider>()
            .getCourse(token: token, id: user['course_id']);
      }
    });
  }

  void _updateControllers(Map user) {
    usernameController.text = user['username'] ?? '';
    emailController.text = user['email'] ?? '';
    phoneController.text = user['phone'] ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = context.watch<UserProvider>().user;
    _updateControllers(user);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<UserProvider>().isLoading;
    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;
    course = context.watch<CoursesProvider>().course;

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          isMinimized
              ? Expanded(flex: 1, child: SideNavigation())
              : SizedBox(width: 80, child: SideNavigation()),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                spacing: 20,
                children: [
                  // Top Bar
                  _buildTopBar(
                    context,
                    user,
                    context.watch<DashboardProvider>().isNewActivities,
                  ),

                  // Main Content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        // Profile Sidebar
                        Expanded(
                          flex: 2,
                          child: Column(
                            spacing: 20,
                            children: [
                              // Profile Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppUtils.mainWhite(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor:
                                          AppUtils.mainBlue(context)
                                              .withOpacity(0.1),
                                      child: Text(
                                        user.isNotEmpty
                                            ? user['username'][0].toUpperCase()
                                            : 'G',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: AppUtils.mainBlue(context),
                                        ),
                                      ),
                                    ),
                                    const Gap(16),
                                    Text(
                                      user.isNotEmpty
                                          ? user['username']
                                          : 'Guest',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppUtils.mainBlack(context),
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      user.isNotEmpty
                                          ? user['email']
                                          : 'guest@email.com',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppUtils.mainGrey(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Navigation Tabs
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppUtils.mainWhite(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  spacing: 4,
                                  children: [
                                    _buildNavTab(
                                      context,
                                      icon: FluentIcons.person_24_regular,
                                      label: 'Account Details',
                                      isSelected: selectedTab == 'account',
                                      onTap: () => setState(
                                          () => selectedTab = 'account'),
                                    ),
                                    _buildNavTab(
                                      context,
                                      icon: FluentIcons
                                          .people_community_24_regular,
                                      label: 'Membership',
                                      isSelected: selectedTab == 'membership',
                                      onTap: () => setState(
                                          () => selectedTab = 'membership'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Main Content Area
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: AppUtils.mainWhite(context),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: selectedTab == 'account'
                                ? _buildAccountDetails(context, isLoading)
                                : _buildMembershipDetails(context),
                          ),
                        ),

                        // Platform Details
                        Expanded(
                          flex: 2,
                          child: PlatformDetails(),
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
    );
  }

  Widget _buildTopBar(
      BuildContext context, Map<dynamic, dynamic> user, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            "User Account",
            style: TextStyle(
              fontSize: 20,
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
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
                onPressed: () => context.go('/settings'),
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

  Widget _buildNavTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppUtils.mainBlue(context).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppUtils.mainBlue(context)
                  : AppUtils.mainGrey(context),
            ),
            const Gap(12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? AppUtils.mainBlue(context)
                    : AppUtils.mainBlack(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppUtils.mainBlue(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FluentIcons.person_24_filled,
                size: 20,
                color: AppUtils.mainBlue(context),
              ),
            ),
            const Gap(12),
            Text(
              "Account Details",
              style: TextStyle(
                fontSize: 22,
                color: AppUtils.mainBlack(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                backgroundColor:
                    WidgetStatePropertyAll(AppUtils.mainBlue(context)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                elevation: WidgetStatePropertyAll(0),
              ),
              onPressed: () => _showDialog(context, user),
              icon: Icon(
                FluentIcons.edit_24_regular,
                size: 18,
                color: Colors.white,
              ),
              label: Text(
                "Edit Account",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Gap(24),
        Divider(color: Colors.grey.shade200, height: 1),
        const Gap(24),

        // Account Info Cards
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                _buildInfoCard(
                  context,
                  icon: FluentIcons.person_24_regular,
                  label: 'Username',
                  value: isLoading
                      ? 'Loading...'
                      : user.isNotEmpty
                          ? user['username']
                          : 'Not available',
                  isLoading: isLoading,
                ),
                _buildInfoCard(
                  context,
                  icon: FluentIcons.mail_24_regular,
                  label: 'Email',
                  value: isLoading
                      ? 'Loading...'
                      : user.isNotEmpty
                          ? user['email']
                          : 'Not available',
                  isLoading: isLoading,
                ),
                _buildInfoCard(
                  context,
                  icon: FluentIcons.call_24_regular,
                  label: 'Phone',
                  value: isLoading
                      ? 'Loading...'
                      : user.isNotEmpty
                          ? user['phone']
                          : 'Not available',
                  isLoading: isLoading,
                ),
                _buildInfoCard(
                  context,
                  icon: FluentIcons.document_24_regular,
                  label: 'Registration Number',
                  value: isLoading
                      ? 'Loading...'
                      : user.isNotEmpty
                          ? user['reg_no']
                          : 'Not available',
                  isLoading: isLoading,
                ),
                _buildInfoCard(
                  context,
                  icon: FluentIcons.book_24_regular,
                  label: 'Course',
                  value: isLoading
                      ? 'Loading...'
                      : course.isNotEmpty
                          ? course['name']
                          : 'Not available',
                  isLoading: isLoading,
                ),
                _buildInfoCard(
                  context,
                  icon: FluentIcons.calendar_24_regular,
                  label: 'Date Joined',
                  value: isLoading
                      ? 'Loading...'
                      : user.isNotEmpty
                          ? AppUtils.formatDate(user['created_at'])
                          : 'Not available',
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),

        const Gap(24),

        // Account Status
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account Status",
                style: TextStyle(
                  fontSize: 14,
                  color: AppUtils.mainGrey(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppUtils.mainRed(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.warning_24_filled,
                          size: 16,
                          color: AppUtils.mainRed(context),
                        ),
                        const Gap(8),
                        Text(
                          "Not Verified",
                          style: TextStyle(
                            color: AppUtils.mainRed(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppUtils.mainGreen(context),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.checkmark_circle_24_filled,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Verify Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Gap(24),

        // Acknowledgment
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    FluentIcons.info_24_regular,
                    size: 18,
                    color: AppUtils.mainBlue(context),
                  ),
                  const Gap(8),
                  Text(
                    "Acknowledgment",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppUtils.mainBlack(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Text(
                "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                style: TextStyle(
                  fontSize: 13,
                  color: AppUtils.mainGrey(context),
                  height: 1.5,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  Text(
                    "Powered by ",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppUtils.mainGrey(context),
                    ),
                  ),
                  Text(
                    "Labs",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppUtils.mainBlue(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembershipDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppUtils.mainBlue(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FluentIcons.people_community_24_filled,
                size: 20,
                color: AppUtils.mainBlue(context),
              ),
            ),
            const Gap(12),
            Text(
              "Account Membership",
              style: TextStyle(
                fontSize: 22,
                color: AppUtils.mainBlack(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Gap(24),
        Divider(color: Colors.grey.shade200, height: 1),
        const Gap(24),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.people_community_24_regular,
                  size: 64,
                  color: AppUtils.mainGrey(context).withOpacity(0.5),
                ),
                const Gap(16),
                Text(
                  "Membership Coming Soon",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                const Gap(8),
                Text(
                  "Membership features will be available here",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppUtils.mainGrey(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppUtils.mainBlue(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppUtils.mainGrey(context),
                  ),
                ),
                const Gap(4),
                isLoading
                    ? Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppUtils.mainBlack(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, Map user) {
    showDialog(
      context: context,
      builder: (context) {
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Account Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppUtils.mainBlue(context),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(FluentIcons.dismiss_24_regular),
                          ),
                        ],
                      ),
                      const Gap(24),

                      // Profile Picture Section
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  AppUtils.mainBlue(context).withOpacity(0.1),
                              child: Text(
                                user.isNotEmpty
                                    ? user['username'][0].toUpperCase()
                                    : 'G',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: AppUtils.mainBlue(context),
                                ),
                              ),
                            ),
                            const Gap(16),
                            OutlinedButton.icon(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                side: WidgetStatePropertyAll(
                                  BorderSide(color: AppUtils.mainBlue(context)),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: Icon(
                                FluentIcons.image_24_regular,
                                size: 18,
                                color: AppUtils.mainBlue(context),
                              ),
                              label: Text(
                                "Change Photo",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppUtils.mainBlue(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(32),

                      // Form Fields
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.person_24_regular),
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
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
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.mail_24_regular),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
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
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.call_24_regular),
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
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
                      const Gap(24),

                      // Save Button
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(vertical: 16),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  userProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: userProvider.isLoading
                                  ? null
                                  : () {
                                      userProvider.editUserDetails(
                                        tokenRef,
                                        emailController.text,
                                        usernameController.text,
                                        phoneController.text,
                                        'user.png',
                                      );
                                      if (userProvider.success) {
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                              icon: userProvider.isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      FluentIcons.save_24_regular,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (context.watch<UserProvider>().success)
              Positioned(
                top: 20,
                right: 20,
                child: SuccessWidget(
                  message: context.watch<UserProvider>().message,
                ),
              )
            else if (context.watch<UserProvider>().error)
              Positioned(
                top: 20,
                right: 20,
                child: FailedWidget(
                  message: context.watch<UserProvider>().message,
                ),
              )
          ],
        );
      },
    );
  }
}
