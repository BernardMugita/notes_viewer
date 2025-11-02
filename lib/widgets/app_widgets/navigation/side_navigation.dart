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

    user = context.read<UserProvider>().user;
    final toggleProvider = context.watch<TogglesProvider>();
    bool isMinimized = toggleProvider.isSideNavMinimized;

    return Container(
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
            padding: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: isMinimized ? 24 : 16,
            ),
            child: Column(
              children: [
                // Logo
                GestureDetector(
                  onTap: () => context.go('/'),
                  child: Hero(
                    tag: 'app_logo',
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isMinimized
                          ? Image(
                              height: 60,
                              width: 60,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  'assets/images/alib-hd-shaddow.png'),
                            )
                          : Image(
                              height: 40,
                              width: 40,
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  'assets/images/alib-hd-shaddow.png'),
                            ),
                    ),
                  ),
                ),
                if (isMinimized) ...[
                  const Gap(12),
                  Text(
                    "Maktaba",
                    style: TextStyle(
                      color: AppUtils.mainWhite(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    "Learning Platform",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: isMinimized ? 24 : 8),
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
              padding: EdgeInsets.symmetric(horizontal: isMinimized ? 16 : 8),
              child: Column(
                children: [
                  // Admin Dashboard (if admin)
                  if (user.isNotEmpty && user['role'] == 'admin') ...[
                    _buildNavItem(
                      context,
                      route: '/maktaba_admin',
                      currentRoute: currentRoute,
                      icon: FluentIcons.shield_keyhole_24_regular,
                      label: 'Admin Panel',
                      isMinimized: isMinimized,
                    ),
                    const Gap(8),
                  ],

                  // Dashboard
                  _buildNavItem(
                    context,
                    route: '/dashboard',
                    currentRoute: currentRoute,
                    icon: FluentIcons.home_24_regular,
                    label: 'Dashboard',
                    isMinimized: isMinimized,
                  ),
                  const Gap(8),

                  // Units
                  _buildNavItem(
                    context,
                    route: '/units',
                    currentRoute: currentRoute,
                    icon: FluentIcons.book_24_regular,
                    label: 'Units',
                    isMinimized: isMinimized,
                  ),
                  const Gap(8),

                  // Settings
                  _buildNavItem(
                    context,
                    route: '/settings',
                    currentRoute: currentRoute,
                    icon: FluentIcons.settings_24_regular,
                    label: 'Settings',
                    isMinimized: isMinimized,
                  ),
                  const Gap(8),

                  // Account
                  _buildNavItem(
                    context,
                    route: '/account',
                    currentRoute: currentRoute,
                    icon: FluentIcons.person_24_regular,
                    label: 'Account',
                    isMinimized: isMinimized,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section
          Container(
            padding: EdgeInsets.all(isMinimized ? 16 : 8),
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
                // User Profile Section (when expanded)
                if (isMinimized)
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
                          radius: 20,
                          backgroundColor: AppUtils.mainWhite(context),
                          child: Text(
                            user.isNotEmpty
                                ? user['username'][0].toUpperCase()
                                : 'G',
                            style: TextStyle(
                              color: AppUtils.mainBlue(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                                  width: 80,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              else
                                Text(
                                  user.isNotEmpty ? user['username'] : 'Guest',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppUtils.mainWhite(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const Gap(4),
                              if (context.watch<UserProvider>().isLoading)
                                Container(
                                  width: 60,
                                  height: 10,
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
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        GestureDetector(
                          onTap: () {
                            toggleProvider.toggleSideNavMinimized();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              FluentIcons.panel_right_contract_24_regular,
                              color: AppUtils.mainWhite(context),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  // Collapsed user avatar
                  GestureDetector(
                    onTap: () {
                      toggleProvider.toggleSideNavMinimized();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        FluentIcons.panel_left_contract_24_regular,
                        color: AppUtils.mainWhite(context),
                        size: 20,
                      ),
                    ),
                  ),

                const Gap(12),

                // Logout Button
                Consumer<AuthProvider>(
                  builder: (context, authContext, child) {
                    return isMinimized
                        ? SizedBox(
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
                                elevation: WidgetStatePropertyAll(0),
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
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              authContext.logout(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppUtils.mainRed(context),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                FluentIcons.sign_out_24_regular,
                                color: Colors.white,
                                size: 20,
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
    );
  }

  /// Builds a navigation item with modern styling and animations
  Widget _buildNavItem(
    BuildContext context, {
    required String route,
    required String? currentRoute,
    required IconData icon,
    required String label,
    required bool isMinimized,
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
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: isMinimized ? 16 : 12,
          ),
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

              if (isMinimized) ...[
                const Gap(12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      color: isActive
                          ? AppUtils.mainWhite(context)
                          : Colors.white.withOpacity(0.9),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],

              // Active indicator
              if (isActive && isMinimized)
                Container(
                  width: 4,
                  height: 4,
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
