import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/utils/app_utils.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    String currentRoute =
        ModalRoute.of(context)!.settings.name!.split('/')[1];

    print(currentRoute);

    return Container(
      decoration: BoxDecoration(color: AppUtils.$mainBlue),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppUtils.$mainWhite,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppUtils.$mainBlue,
                ),
                const Gap(10),
                Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppUtils.$mainBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("fullname@email.com"),
              ],
            ),
          ),
          const Gap(40),
          Expanded(
            child: Column(
              children: [
                // Dashboard Menu Item
                _buildNavItem(
                  context,
                  route: '/',
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
          ElevatedButton(
            onPressed: () {},
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
                  style: TextStyle(fontSize: 16, color: AppUtils.$mainBlack),
                ),
              ],
            ),
          ),
        ],
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
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? AppUtils.$mainWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(color: AppUtils.$mainGrey),
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
