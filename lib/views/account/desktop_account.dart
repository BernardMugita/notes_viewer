import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/side_navigation/side_navigation.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.horizontal,
            children: [
          Expanded(
            flex: 1,
            child: const SideNavigation(),
          ),
          Expanded(
              flex: 6,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Row(
                      children: [
                        const Icon(
                          FluentIcons.person_28_regular,
                          color: AppUtils.$mainBlue,
                        ),
                        const Gap(5),
                        Text(
                          "User Account",
                          style: TextStyle(
                            fontSize: 30,
                            color: AppUtils.$mainBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
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
                      ],
                    ),
                    const Gap(10),
                    const Divider(
                      color: Color(0xFFCECECE),
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
                              SizedBox(
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
                              SizedBox(
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
                              )
                            ],
                          ),
                        ),
                        Gap(40),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              height: MediaQuery.of(context).size.height * 0.85,
                              decoration: BoxDecoration(
                                color: AppUtils.$mainWhite,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Account Details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppUtils.$mainBlue,
                                          fontWeight: FontWeight.bold)),
                                  Gap(30),
                                  _buildAccountDetails(context,
                                      title: 'Username', value: 'JeromeMugita'),
                                  _buildAccountDetails(context,
                                      title: 'Email',
                                      value: 'username@email.com'),
                                  _buildAccountDetails(context,
                                      title: 'Phone', value: '+1 123 456'),
                                  _buildAccountDetails(context,
                                      title: 'Registration number',
                                      value: 'REG/022/2025'),
                                  _buildAccountDetails(context,
                                      title: 'Course',
                                      value:
                                          'Bachelors Degree in Computer Science'),
                                  _buildAccountDetails(context,
                                      title: 'Date Joined',
                                      value: '20th March 2025'),
                                  Spacer(),
                                  Divider(),
                                  Gap(5),
                                  Text(
                                    "Acknowledgment",
                                    style: TextStyle(color: AppUtils.$mainBlue),
                                  ),
                                  Gap(5),
                                  Text(
                                    "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                    style: TextStyle(color: AppUtils.$mainGrey),
                                  ),
                                  Text("Powered by Labs")
                                ],
                              ),
                            )),
                        Expanded(flex: 2, child: SizedBox())
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
            child: Text(value)),
        Positioned(
            top: -10,
            left: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: AppUtils.$mainWhite,
              child: Text(
                title,
                style: TextStyle(color: AppUtils.$mainGrey, fontSize: 12),
              ),
            ))
      ],
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                                backgroundColor:
                                    WidgetStatePropertyAll(AppUtils.$mainBlue),
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
                  ElevatedButton(
                      style: ButtonStyle(
                        padding:
                            WidgetStatePropertyAll(const EdgeInsets.all(20)),
                        backgroundColor:
                            WidgetStatePropertyAll(AppUtils.$mainBlue),
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
                            FluentIcons.save_24_regular,
                            color: AppUtils.$mainWhite,
                          ),
                          Gap(10),
                          Text("Save Changes",
                              style: TextStyle(
                                  fontSize: 16, color: AppUtils.$mainWhite)),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}
