import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
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
    final currentRoute = routeName != null && routeName.contains('/')
        ? routeName.split('/')[1]
        : routeName!.startsWith('notes')
            ? 'units'
            : routeName;

    user = context.watch<UserProvider>().user;

    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(color: AppUtils.mainBlue(context)),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image(
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/alib-hd-shaddow.png')),
            Text(
              "Maktaba",
              style: TextStyle(color: AppUtils.mainWhite(context)),
            ),
            const Gap(40),
            Expanded(
              child: Column(
                children: [
                  // admin Menu Item
                  if (user.isNotEmpty && user['role'] == 'admin')
                    _buildNavItem(
                      context,
                      route: '/maktaba_admin',
                      currentRoute: currentRoute,
                      icon: FluentIcons.guardian_24_regular,
                      label: 'Maktaba Admin',
                    ),
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
                        border:
                            Border.all(color: AppUtils.mainBlueAccent(context)),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Icon(FluentIcons.person_24_regular),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (context.watch<UserProvider>().isLoading)
                              LinearProgressIndicator(
                                color: AppUtils.mainWhite(context),
                              )
                            else
                              Text(user.isNotEmpty ? user['username'] : 'Guest',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainWhite(context),
                                      fontWeight: FontWeight.bold)),
                            if (context.watch<UserProvider>().isLoading)
                              LinearProgressIndicator(
                                color: AppUtils.mainWhite(context),
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
                                        color: AppUtils.mainWhite(context))),
                              ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          FluentIcons.more_vertical_24_regular,
                          color: AppUtils.mainWhite(context),
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
                        color: AppUtils.mainBlack(context)),
                    const Gap(5),
                    Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 16, color: AppUtils.mainBlack(context)),
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

    final toggleProvider = context.read<TogglesProvider>();

    return GestureDetector(
      onTap: () => {context.go(route), toggleProvider.deActivateSearchMode()},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? AppUtils.mainWhite(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive
                    ? AppUtils.mainBlue(context)
                    : AppUtils.mainWhite(context)),
            const Gap(5),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isActive
                    ? AppUtils.mainBlue(context)
                    : AppUtils.mainWhite(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
