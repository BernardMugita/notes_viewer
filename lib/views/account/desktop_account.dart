import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:note_viewer/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';
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

  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<UserProvider>().fetchUserDetails(token);
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

    return Scaffold(
        body: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 20, bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "User Account",
                              style: TextStyle(
                                fontSize: 24,
                                color: AppUtils.$mainBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
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
                              _showDialog(context, user);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Edit Account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppUtils.$mainWhite,
                                  ),
                                ),
                                const Gap(5),
                                Icon(
                                  FluentIcons.person_edit_24_regular,
                                  size: 16,
                                  color: AppUtils.$mainWhite,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 100,
                                    backgroundColor: AppUtils.$mainWhite,
                                    child: Image(
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/placeholder-profile.png'),
                                    ),
                                  ),
                                  Gap(40),
                                  Consumer<TogglesProvider>(builder:
                                      (context, toggleProvider, child) {
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
                                              color: AppUtils.$mainBlue,
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
                                              color: AppUtils.$mainBlue,
                                            ),
                                            Gap(5),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            Gap(40),
                            Expanded(
                                flex: 3,
                                child: Consumer<TogglesProvider>(builder: (
                                  context,
                                  toggleProvider,
                                  child,
                                ) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    decoration: BoxDecoration(
                                      color: AppUtils.$mainWhite,
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: toggleProvider.accountView
                                            ? [
                                                Text("Account Details",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            AppUtils.$mainBlue,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Gap(30),
                                                _buildAccountDetails(context,
                                                    title: 'Username',
                                                    value: isLoading
                                                        ? 'username'
                                                        : user.isNotEmpty
                                                            ? user['username']
                                                            : 'Details not found'),
                                                _buildAccountDetails(context,
                                                    title: 'Email',
                                                    value: isLoading
                                                        ? 'email'
                                                        : user.isNotEmpty
                                                            ? user['email']
                                                            : 'Details not found'),
                                                _buildAccountDetails(context,
                                                    title: 'Phone',
                                                    value: isLoading
                                                        ? 'phone'
                                                        : user.isNotEmpty
                                                            ? user['phone']
                                                            : 'Details not found'),
                                                _buildAccountDetails(context,
                                                    title:
                                                        'Registration number',
                                                    value: isLoading
                                                        ? 'reg_no'
                                                        : user.isNotEmpty
                                                            ? user['reg_no']
                                                            : 'Details not found'),
                                                _buildAccountDetails(context,
                                                    title: 'Course',
                                                    value:
                                                        'Bachelors Degree in Computer Science'),
                                                _buildAccountDetails(context,
                                                    title: 'Date Joined',
                                                    value: isLoading
                                                        ? '0/0/2025'
                                                        : user.isNotEmpty
                                                            ? AppUtils
                                                                .formatDate(user[
                                                                    'created_at'])
                                                            : 'Details not found'),
                                                Spacer(),
                                                Text("Account status:"),
                                                Gap(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 10,
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: const Color
                                                              .fromARGB(
                                                              87, 255, 25, 0)),
                                                      child: Text(
                                                        "Not verified",
                                                        style: TextStyle(
                                                            color: AppUtils
                                                                .$mainRed),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                        padding:
                                                            WidgetStatePropertyAll(
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 5,
                                                                    bottom: 5)),
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                AppUtils
                                                                    .$mainBlue),
                                                        shape:
                                                            WidgetStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                              color: AppUtils
                                                                  .$mainWhite,
                                                            ),
                                                          ),
                                                          const Gap(5),
                                                          Icon(
                                                            FluentIcons
                                                                .checkmark_circle_24_filled,
                                                            size: 16,
                                                            color: AppUtils
                                                                .$mainWhite,
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
                                                          AppUtils.$mainBlue),
                                                ),
                                                Gap(5),
                                                Text(
                                                  "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                                  style: TextStyle(
                                                      color:
                                                          AppUtils.$mainGrey),
                                                ),
                                                Text("Powered by Labs")
                                              ]
                                            : toggleProvider.membershipView
                                                ? [
                                                    Text("Account Membership",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: AppUtils
                                                                .$mainBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Gap(30),
                                                    Spacer(),
                                                    Gap(10),
                                                    Divider(),
                                                    Gap(5),
                                                    Text(
                                                      "Acknowledgment",
                                                      style: TextStyle(
                                                          color: AppUtils
                                                              .$mainBlue),
                                                    ),
                                                    Gap(5),
                                                    Text(
                                                      "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                                      style: TextStyle(
                                                          color: AppUtils
                                                              .$mainGrey),
                                                    ),
                                                    Text("Powered by Labs")
                                                  ]
                                                : []),
                                  );
                                })),
                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                            Expanded(flex: 1, child: PlatformDetails())
                          ],
                        )
                      ])))
        ]));
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
                border: Border(bottom: BorderSide(color: AppUtils.$mainGrey)),
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
              color: AppUtils.$mainWhite,
              child: context.watch<UserProvider>().isLoading
                  ? SizedBox(
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    )
                  : Text(
                      title,
                      style: TextStyle(color: AppUtils.$mainGrey, fontSize: 12),
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
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: AppUtils.$mainWhite,
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
                                  color: AppUtils.$mainBlue)),
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
                              radius: 100,
                              backgroundColor: AppUtils.$mainBlueAccent,
                              child: Image(
                                height: 140,
                                width: 140,
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
                                        const EdgeInsets.all(20)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppUtils.$mainBlue),
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
                                        color: AppUtils.$mainWhite,
                                      ),
                                      Gap(10),
                                      Text("Browse",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppUtils.$mainWhite)),
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
                          focusColor: AppUtils.$mainBlue,
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
                          focusColor: AppUtils.$mainBlue,
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
                          focusColor: AppUtils.$mainBlue,
                        ),
                      ),
                      Spacer(),
                      Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                        return ElevatedButton(
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
                                  color: AppUtils.$mainWhite,
                                ),
                                Gap(10),
                                Text("Save Changes",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppUtils.$mainWhite)),
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
