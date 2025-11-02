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
  String? _hoveredRoute;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppUtils.mainBlue(context),
              AppUtils.mainBlue(context).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Hero(
                      tag: 'app_logo',
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image(
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                          image:
                              AssetImage('assets/images/alib-hd-shaddow.png'),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Text(
                    "Maktaba",
                    style: TextStyle(
                      color: AppUtils.mainWhite(context),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    "Learning Platform",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
            const Gap(24),

            // Navigation Items
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Admin Menu Item
                    if (user.isNotEmpty && user['role'] == 'admin') ...[
                      _buildNavItem(
                        context,
                        route: '/maktaba_admin',
                        currentRoute: currentRoute,
                        icon: FluentIcons.shield_keyhole_24_regular,
                        label: 'Admin Panel',
                      ),
                      const Gap(8),
                    ],

                    // Dashboard Menu Item
                    _buildNavItem(
                      context,
                      route: '/dashboard',
                      currentRoute: currentRoute,
                      icon: FluentIcons.home_24_regular,
                      label: 'Dashboard',
                    ),
                    const Gap(8),

                    // Units Menu Item
                    _buildNavItem(
                      context,
                      route: '/units',
                      currentRoute: currentRoute,
                      icon: FluentIcons.book_24_regular,
                      label: 'Units',
                    ),
                    const Gap(8),

                    // Settings Menu Item
                    _buildNavItem(
                      context,
                      route: '/settings',
                      currentRoute: currentRoute,
                      icon: FluentIcons.settings_24_regular,
                      label: 'Settings',
                    ),
                    const Gap(8),

                    // Account Menu Item
                    _buildNavItem(
                      context,
                      route: '/account',
                      currentRoute: currentRoute,
                      icon: FluentIcons.person_24_regular,
                      label: 'Account',
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // User Profile Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppUtils.mainWhite(context),
                          child: Text(
                            user.isNotEmpty
                                ? user['username'][0].toUpperCase()
                                : 'G',
                            style: TextStyle(
                              color: AppUtils.mainBlue(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (context.watch<UserProvider>().isLoading)
                                Container(
                                  width: 100,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              else
                                Text(
                                  user.isNotEmpty ? user['username'] : 'Guest',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppUtils.mainWhite(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const Gap(4),
                              if (context.watch<UserProvider>().isLoading)
                                Container(
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              else
                                Text(
                                  user.isNotEmpty
                                      ? user['email']
                                      : 'guest@email.com',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            FluentIcons.more_vertical_24_regular,
                            color: AppUtils.mainWhite(context),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),

                  // Logout Button
                  Consumer<AuthProvider>(
                    builder: (context, authContext, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            authContext.logout(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppUtils.mainRed(context),
                            ),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 14),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            elevation: const WidgetStatePropertyAll(0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FluentIcons.sign_out_24_regular,
                                color: Colors.white,
                                size: 18,
                              ),
                              const Gap(8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a navigation item with modern styling and animations
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required String currentRoute,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentRoute == route.replaceAll('/', '');
    final isHovered = _hoveredRoute == route;
    final toggleProvider = context.read<TogglesProvider>();

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRoute = route),
      onExit: (_) => setState(() => _hoveredRoute = null),
      child: GestureDetector(
        onTap: () {
          context.go(route);
          toggleProvider.deActivateSearchMode();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withOpacity(0.2)
                : isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  isActive ? Colors.white.withOpacity(0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppUtils.mainWhite(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? AppUtils.mainBlue(context)
                      : AppUtils.mainWhite(context),
                  size: 22,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: isActive
                        ? AppUtils.mainWhite(context)
                        : Colors.white.withOpacity(0.9),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              // Active indicator
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
