import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/user_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:provider/provider.dart';

class ResponsiveNav extends StatefulWidget {
  const ResponsiveNav({super.key});

  @override
  State<ResponsiveNav> createState() => _ResponsiveNavState();
}

class _ResponsiveNavState extends State<ResponsiveNav> {
  Map<String, dynamic> user = {};

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

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name;
    final currentRoute = routeName != null ? routeName.split('/')[1] : '';

    user = context.watch<UserProvider>().user;

    print(user);

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(color: AppUtils.$mainBlue),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image(
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/NV_logo.png')),
            const Gap(40),
            Expanded(
              child: Column(
                children: [
                  // Dashboard Menu Item
                  _buildNavItem(
                    context,
                    route: '/dashboard',
                    currentRoute: currentRoute,
                    icon: FluentIcons.gauge_24_regular,
                    label: 'Dashboard',
                  ),
                  const Gap(10),
                  // Units Menu Item
                  _buildNavItem(
                    context,
                    route: '/units',
                    currentRoute: currentRoute,
                    icon: FluentIcons.class_24_regular,
                    label: 'Units',
                  ),
                  const Gap(10),
                  // Settings Menu Item
                  _buildNavItem(
                    context,
                    route: '/settings',
                    currentRoute: currentRoute,
                    icon: FluentIcons.settings_24_regular,
                    label: 'Settings',
                  ),
                  const Gap(10),
                  // Account Menu Item
                  _buildNavItem(
                    context,
                    route: '/account',
                    currentRoute: currentRoute,
                    icon: FluentIcons.person_accounts_24_regular,
                    label: 'Account',
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppUtils.$mainBlueAccent),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Image(
                              height: 25,
                              width: 25,
                              image: AssetImage(
                                  'assets/images/placeholder-profile.png')),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (context.watch<UserProvider>().isLoading)
                              LinearProgressIndicator(
                                color: AppUtils.$mainWhite,
                              )
                            else
                              Text(user.isNotEmpty ? user['username'] : 'Guest',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.$mainWhite,
                                      fontWeight: FontWeight.bold)),
                            if (context.watch<UserProvider>().isLoading)
                              LinearProgressIndicator(
                                color: AppUtils.$mainWhite,
                              )
                            else
                              SizedBox(
                                width: 100,
                                child: Text(
                                    user.isNotEmpty
                                        ? user['email']
                                        : 'guest@email.com',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 12,
                                        color: AppUtils.$mainWhite)),
                              ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          FluentIcons.more_vertical_24_regular,
                          color: AppUtils.$mainWhite,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(5),
            Consumer<AuthProvider>(builder: (context, authContext, child) {
              return ElevatedButton(
                onPressed: () {
                  authContext.logout(context);
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.sign_out_24_regular,
                        color: AppUtils.$mainBlack),
                    const Gap(5),
                    const Text(
                      'Logout',
                      style:
                          TextStyle(fontSize: 16, color: AppUtils.$mainBlack),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Builds a navigation item with dynamic styling for active route
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required String currentRoute,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentRoute == route.replaceAll('/', '');

    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? AppUtils.$mainWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? AppUtils.$mainBlue : AppUtils.$mainWhite),
            const Gap(5),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isActive ? AppUtils.$mainBlue : AppUtils.$mainWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
