import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/confirm_exit.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class MobileAccount extends StatefulWidget {
  const MobileAccount({super.key});

  @override
  State<MobileAccount> createState() => _MobileAccountState();
}

class _MobileAccountState extends State<MobileAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController regNoController = TextEditingController();

  Map user = {};
  Map course = {};

  String tokenRef = '';

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
            .fetchCourse(token: token, id: user['course_id']);
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
    final isLoading = context.watch<UserProvider>().isLoading;
    final course = context.watch<CoursesProvider>().course;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmExit(),
        );

        return shouldExit ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppUtils.backgroundPanel(context),
        appBar: AppBar(
          backgroundColor: AppUtils.mainBlue(context),
          leading: GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Icon(
              FluentIcons.re_order_24_regular,
              color: AppUtils.mainWhite(context),
            ),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Top Title + Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "User Account",
                      style: TextStyle(
                        fontSize: 24,
                        color: AppUtils.mainBlue(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppUtils.mainBlue(context)),
                        padding:
                            WidgetStatePropertyAll(const EdgeInsets.all(16)),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      onPressed: () => _showDialog(context, user),
                      child: Icon(
                        FluentIcons.person_edit_24_regular,
                        size: 16,
                        color: AppUtils.mainWhite(context),
                      ),
                    )
                  ],
                ),
                const Gap(20),

                // Toggle Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<TogglesProvider>(
                      builder: (context, toggleProvider, _) => GestureDetector(
                        onTap: toggleProvider.toggleAccountView,
                        child: _buildToggleRow(
                          icon: FluentIcons.person_accounts_24_regular,
                          label: "Account Details",
                          context: context,
                        ),
                      ),
                    ),
                    Consumer<TogglesProvider>(
                      builder: (context, toggleProvider, _) => GestureDetector(
                        onTap: toggleProvider.toggleMembershipView,
                        child: _buildToggleRow(
                          icon: FluentIcons.people_community_24_regular,
                          label: "Account Memberships",
                          context: context,
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(20),

                // Main Card Content
                Consumer<TogglesProvider>(
                  builder: (context, toggleProvider, _) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppUtils.mainWhite(context),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: toggleProvider.accountView
                          ? _buildAccountDetailsSection(
                              context, isLoading, course)
                          : toggleProvider.membershipView
                              ? _buildMembershipSection(context)
                              : const SizedBox(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppUtils.mainBlue(context)),
            const Gap(5),
            Text(label),
          ],
        ),
        const Gap(5),
        Divider(thickness: 0.5, color: AppUtils.mainBlue(context)),
        const Gap(5),
      ],
    );
  }

  Widget _buildAccountDetailsSection(
      BuildContext context, bool isLoading, Map course) {
    final user = context.read<UserProvider>().user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Account Details",
            style: TextStyle(
                fontSize: 18,
                color: AppUtils.mainBlue(context),
                fontWeight: FontWeight.bold)),
        const Gap(30),
        _buildAccountDetails(context,
            title: 'Username',
            value: isLoading ? 'username' : user['username']),
        _buildAccountDetails(context,
            title: 'Email', value: isLoading ? 'email' : user['email']),
        _buildAccountDetails(context,
            title: 'Phone', value: isLoading ? 'phone' : user['phone']),
        _buildAccountDetails(context,
            title: 'Registration number',
            value: isLoading ? 'reg_no' : user['reg_no']),
        _buildAccountDetails(
          context,
          title: 'Course',
          value: isLoading
              ? 'course'
              : (course.isNotEmpty ? course['name'] : 'Details not found'),
        ),
        _buildAccountDetails(context,
            title: 'Date Joined',
            value: isLoading
                ? '0/0/2025'
                : AppUtils.formatDate(user['created_at'])),
        const Gap(10),
        Text("Account status:"),
        const Gap(5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(87, 255, 25, 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Not verified",
                style: TextStyle(color: AppUtils.mainRed(context)),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(AppUtils.mainBlue(context)),
                padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    "Verify Account",
                    style: TextStyle(color: AppUtils.mainWhite(context)),
                  ),
                  const Gap(5),
                  Icon(FluentIcons.checkmark_circle_24_filled,
                      size: 16, color: AppUtils.mainWhite(context)),
                ],
              ),
            )
          ],
        ),
        const Gap(20),
        _buildAcknowledgment(context),
      ],
    );
  }

  Widget _buildMembershipSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Account Membership",
            style: TextStyle(
                fontSize: 18,
                color: AppUtils.mainBlue(context),
                fontWeight: FontWeight.bold)),
        const Spacer(),
        const Gap(20),
        _buildAcknowledgment(context),
      ],
    );
  }

  Widget _buildAcknowledgment(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Gap(5),
        Text(
          "Acknowledgment",
          style: TextStyle(color: AppUtils.mainBlue(context)),
        ),
        const Gap(5),
        Text(
          "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
          style: TextStyle(color: AppUtils.mainGrey(context)),
        ),
        const Text("Powered by Labs"),
      ],
    );
  }

  Widget _buildAccountDetails(BuildContext context,
      {required String title, required String value}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppUtils.mainGrey(context))),
                borderRadius: BorderRadius.circular(5)),
            child: context.watch<UserProvider>().isLoading
                ? SizedBox(
                    width: double.infinity,
                    child: LinearProgressIndicator(),
                  )
                : Text(value)),
        Positioned(
            top: -10,
            left: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: AppUtils.mainWhite(context),
              child: context.watch<UserProvider>().isLoading
                  ? SizedBox(
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    )
                  : Text(
                      title,
                      style: TextStyle(
                          color: AppUtils.mainGrey(context), fontSize: 12),
                    ),
            ))
      ],
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
                content: Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: double.infinity,
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
                          Text("Edit your account details",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppUtils.mainBlue(context))),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(FluentIcons.dismiss_24_regular),
                          ),
                        ],
                      ),
                      Gap(30),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: AppUtils.mainBlueAccent(context),
                              child: Image(
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/placeholder-profile.png'),
                              ),
                            ),
                            Gap(20),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        const EdgeInsets.all(5)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.mainBlue(context)),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FluentIcons.image_24_regular,
                                        color: AppUtils.mainWhite(context),
                                      ),
                                      Gap(10),
                                      Text("Browse",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  AppUtils.mainWhite(context))),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                      Gap(20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.mail_24_regular),
                          labelText: 'Email',
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212))),
                          focusColor: AppUtils.mainBlue(context),
                        ),
                      ),
                      Gap(10),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.person_24_regular),
                          labelText: 'Username',
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212))),
                          focusColor: AppUtils.mainBlue(context),
                        ),
                      ),
                      Gap(10),
                      TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(FluentIcons.call_24_regular),
                          labelText: 'Phone',
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 212, 212, 212))),
                          focusColor: AppUtils.mainBlue(context),
                        ),
                      ),
                      Spacer(),
                      Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                        return ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  const EdgeInsets.all(5)),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppUtils.mainBlue(context)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
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
                                        'user.png');
                                    if (userProvider.success) {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.save_24_regular,
                                  color: AppUtils.mainWhite(context),
                                ),
                                Gap(10),
                                Text("Save Changes",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.mainWhite(context))),
                              ],
                            ));
                      })
                    ],
                  ),
                ),
              ),
              if (context.watch<UserProvider>().success)
                Positioned(
                    top: 20,
                    right: 20,
                    child: SuccessWidget(
                        message: context.watch<UserProvider>().message))
              else if (context.watch<UserProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<UserProvider>().message),
                )
            ],
          );
        });
  }
}
