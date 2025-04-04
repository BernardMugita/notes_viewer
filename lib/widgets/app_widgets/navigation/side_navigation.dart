import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class SideNavigation extends StatefulWidget {
  const SideNavigation({super.key});

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
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

    user = context.read<UserProvider>().user;
    final toggleProvider = context.watch<TogglesProvider>();

    bool isMinimized = toggleProvider.isSideNavMinimized;

    return Container(
      decoration: BoxDecoration(color: AppUtils.mainBlue(context)),
      padding: !isMinimized
          ? const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20)
          : const EdgeInsets.all(20),
      child: Column(
        children: [
          if (!isMinimized)
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 30,
              child:
                  Image(image: AssetImage('assets/images/alib-hd-shaddow.png')),
            )
          else
            Image(
                height: 250,
                width: 250,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/alib-hd-shaddow.png')),
          !isMinimized
              ? SizedBox()
              : Text(
                  "Maktaba",
                  style: TextStyle(
                      color: AppUtils.mainWhite(context), fontSize: 20),
                ),
          !isMinimized ? Spacer() : const Gap(40),
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
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: !isMinimized
                    ? Border.all(width: 0, color: Colors.transparent)
                    : Border.all(color: AppUtils.mainBlueAccent(context)),
                borderRadius: BorderRadius.circular(5)),
            padding: !isMinimized
                ? const EdgeInsets.all(0)
                : const EdgeInsets.all(10),
            child: !isMinimized
                ? SizedBox()
                : Row(
                    children: [
                      CircleAvatar(
                        child: Icon(FluentIcons.person_24_regular),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (context.watch<UserProvider>().isLoading)
                            SizedBox(
                              width: 80,
                              child: LinearProgressIndicator(
                                minHeight: 1,
                                color: AppUtils.mainWhite(context),
                              ),
                            )
                          else
                            Text(user.isNotEmpty ? user['username'] : 'Guest',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppUtils.mainWhite(context),
                                    fontWeight: FontWeight.bold)),
                          if (context.watch<UserProvider>().isLoading)
                            SizedBox(
                              width: 50,
                              child: LinearProgressIndicator(
                                minHeight: 1,
                                color: AppUtils.mainWhite(context),
                              ),
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
                      if (isMinimized) Spacer(),
                      if (isMinimized)
                        Consumer<TogglesProvider>(
                            builder: (context, toggleProvider, child) {
                          return GestureDetector(
                            onTap: () {
                              toggleProvider.toggleSideNavMinimized();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppUtils.mainBlueAccent(context),
                              child: Icon(
                                  FluentIcons.panel_right_expand_20_regular,
                                  color: AppUtils.mainBlue(context)),
                            ),
                          );
                        }),
                    ],
                  ),
          ),
          Gap(5),
          if (!isMinimized)
            Consumer<TogglesProvider>(
                builder: (context, toggleProvider, child) {
              return GestureDetector(
                onTap: () {
                  toggleProvider.toggleSideNavMinimized();
                },
                child: CircleAvatar(
                  backgroundColor: AppUtils.mainBlueAccent(context),
                  child: Icon(FluentIcons.panel_left_expand_20_regular,
                      color: AppUtils.mainBlue(context)),
                ),
              );
            }),
          Gap(5),
          Consumer<AuthProvider>(builder: (context, authContext, child) {
            return isMinimized
                ? ElevatedButton(
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
                  )
                : GestureDetector(
                    onTap: () {
                      authContext.logout(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppUtils.mainBlueAccent(context),
                      child: Icon(FluentIcons.sign_out_24_regular,
                          color: AppUtils.mainBlue(context)),
                    ),
                  );
          })
        ],
      ),
    );
  }

  /// Builds a navigation item with dynamic styling for active route
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required String? currentRoute,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentRoute == route.replaceAll('/', '');

    final toggleProvider = context.read<TogglesProvider>();

    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;

    return GestureDetector(
      onTap: () => {context.go(route), toggleProvider.deActivateSearchMode()},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
              left: isActive
                  ? BorderSide(width: 5, color: AppUtils.mainWhite(context))
                  : BorderSide.none),
        ),
        child: !isMinimized
            ? Icon(icon, color: AppUtils.mainWhite(context))
            : Row(
                children: [
                  Icon(icon, color: AppUtils.mainWhite(context)),
                  const Gap(5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
