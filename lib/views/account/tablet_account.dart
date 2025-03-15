import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
// import 'package:maktaba/widgets/app_widgets/membership_banner/membership_banner.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/responsive_nav.dart';
import 'package:provider/provider.dart';

class TabletAccount extends StatefulWidget {
  const TabletAccount({super.key});

  @override
  State<TabletAccount> createState() => _TabletAccountState();
}

class _TabletAccountState extends State<TabletAccount> {
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
    bool isLoading = context.watch<UserProvider>().isLoading;
    course = context.watch<CoursesProvider>().course;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(FluentIcons.re_order_24_regular),
          ),
        ),
        drawer: const ResponsiveNav(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    // if (!context
                    //           .watch<TogglesProvider>()
                    //           .isBannerDismissed)
                    //         Consumer<TogglesProvider>(
                    //         builder: (context, toggleProvider, _) {
                    //       return toggleProvider.isBannerDismissed
                    //           ? SizedBox()
                    //           : MembershipBanner();
                    //     }),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          "User Account",
                          style: TextStyle(
                            fontSize: 24,
                            color: AppUtils.mainBlue(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  const EdgeInsets.all(10)),
                              backgroundColor: WidgetStatePropertyAll(
                                  AppUtils.mainBlue(context)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _showDialog(context, user);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.person_edit_24_regular,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Consumer<TogglesProvider>(
                                builder: (context, toggleProvider, child) {
                              return GestureDetector(
                                onTap: () {
                                  toggleProvider.toggleAccountView();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FluentIcons
                                              .person_accounts_24_regular),
                                          Gap(5),
                                          Text("Account Details")
                                        ],
                                      ),
                                      Gap(5),
                                      Divider(
                                        thickness: 0.5,
                                        color: AppUtils.mainBlue(context),
                                      ),
                                      Gap(5),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Consumer<TogglesProvider>(builder: (
                              context,
                              toggleProvider,
                              child,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  toggleProvider.toggleMembershipView();
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FluentIcons
                                              .people_community_24_regular),
                                          Gap(5),
                                          Text("Account Memberships")
                                        ],
                                      ),
                                      Gap(5),
                                      Divider(
                                        thickness: 0.5,
                                        color: AppUtils.mainBlue(context),
                                      ),
                                      Gap(5),
                                    ],
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                        Gap(20),
                        Consumer<TogglesProvider>(builder: (
                          context,
                          toggleProvider,
                          child,
                        ) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              color: AppUtils.mainWhite(context),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: toggleProvider.accountView
                                    ? [
                                        Text("Account Details",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    AppUtils.mainBlue(context),
                                                fontWeight: FontWeight.bold)),
                                        Gap(30),
                                        _buildAccountDetails(context,
                                            title: 'Username',
                                            value: isLoading
                                                ? 'username'
                                                : user['username']),
                                        _buildAccountDetails(context,
                                            title: 'Email',
                                            value: isLoading
                                                ? 'email'
                                                : user['email']),
                                        _buildAccountDetails(context,
                                            title: 'Phone',
                                            value: isLoading
                                                ? 'phone'
                                                : user['phone']),
                                        _buildAccountDetails(context,
                                            title: 'Registration number',
                                            value: isLoading
                                                ? 'reg_no'
                                                : user['reg_no']),
                                        _buildAccountDetails(context,
                                            title: 'Course',
                                            value: isLoading
                                                ? 'course'
                                                : course.isNotEmpty
                                                    ? course['name']
                                                    : 'Details not found'),
                                        _buildAccountDetails(context,
                                            title: 'Date Joined',
                                            value: isLoading
                                                ? '0/0/2025'
                                                : AppUtils.formatDate(
                                                    user['created_at'])),
                                        Spacer(),
                                        Text("Account status:"),
                                        Gap(5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: const Color.fromARGB(
                                                      87, 255, 25, 0)),
                                              child: Text(
                                                "Not verified",
                                                style: TextStyle(
                                                    color: AppUtils.mainRed(
                                                        context)),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                padding: WidgetStatePropertyAll(
                                                    const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5,
                                                        bottom: 5)),
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        AppUtils.mainBlue(
                                                            context)),
                                                shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Verify Account",
                                                    style: TextStyle(
                                                      color: AppUtils.mainWhite(
                                                          context),
                                                    ),
                                                  ),
                                                  const Gap(5),
                                                  Icon(
                                                    FluentIcons
                                                        .checkmark_circle_24_filled,
                                                    size: 16,
                                                    color: AppUtils.mainWhite(
                                                        context),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Gap(10),
                                        Divider(),
                                        Gap(5),
                                        Text(
                                          "Acknowledgment",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainBlue(context)),
                                        ),
                                        Gap(5),
                                        Text(
                                          "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                          style: TextStyle(
                                              color:
                                                  AppUtils.mainGrey(context)),
                                        ),
                                        Text("Powered by Labs")
                                      ]
                                    : toggleProvider.membershipView
                                        ? [
                                            Text("Account Membership",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: AppUtils.mainBlue(
                                                        context),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Gap(30),
                                            Spacer(),
                                            Gap(10),
                                            Divider(),
                                            Gap(5),
                                            Text(
                                              "Acknowledgment",
                                              style: TextStyle(
                                                  color: AppUtils.mainBlue(
                                                      context)),
                                            ),
                                            Gap(5),
                                            Text(
                                              "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                              style: TextStyle(
                                                  color: AppUtils.mainGrey(
                                                      context)),
                                            ),
                                            Text("Powered by Labs")
                                          ]
                                        : []),
                          );
                        }),
                        const Gap(40),
                        SizedBox(
                          child: Center(
                            child: PlatformDetails(),
                          ),
                        )
                      ],
                    )
                  ])),
        ));
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text("Edit your account details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        color: AppUtils.mainBlue(context)))),
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
                                backgroundColor:
                                    AppUtils.mainBlueAccent(context),
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.image_24_regular,
                                          color: AppUtils.mainWhite(context),
                                        ),
                                        Gap(10),
                                        Text("Browse",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppUtils.mainWhite(
                                                    context))),
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
                            prefixIcon:
                                const Icon(FluentIcons.person_24_regular),
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
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
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
