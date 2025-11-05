import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/dashboard_provider.dart';
import 'package:maktaba/providers/theme_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/user_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/platform_widgets/platform_details.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class DesktopSettings extends StatefulWidget {
  const DesktopSettings({super.key});

  @override
  State<DesktopSettings> createState() => _DesktopSettingsState();
}

class _DesktopSettingsState extends State<DesktopSettings> {
  @override
  Widget build(BuildContext context) {
    bool isMinimized = context.watch<TogglesProvider>().isSideNavMinimized;
    final themeProvider = context.read<ThemeProvider>();
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
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
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                top: 20,
                bottom: 20,
              ),
              child: Column(
                spacing: 20,
                children: [
                  // Top Bar
                  _buildTopBar(
                    context,
                    user,
                    context.watch<DashboardProvider>().isNewActivities,
                  ),

                  // Main Content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        // Settings Panel
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: AppUtils.mainWhite(context),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppUtils.mainBlue(context)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        FluentIcons.settings_24_filled,
                                        size: 20,
                                        color: AppUtils.mainBlue(context),
                                      ),
                                    ),
                                    const Gap(12),
                                    Text(
                                      "Settings",
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: AppUtils.mainBlack(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(24),
                                Divider(
                                  color: Colors.grey.shade200,
                                  height: 1,
                                ),
                                const Gap(24),

                                // Settings Section
                                Text(
                                  "Preferences",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppUtils.mainGrey(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Gap(20),

                                // Appearance Setting
                                _buildSettingCard(
                                  context,
                                  icon: FluentIcons.weather_sunny_24_regular,
                                  title: 'Appearance',
                                  subtitle:
                                      'Customize your interface theme and visual preferences',
                                  trailing:
                                      _buildThemeToggle(context, themeProvider),
                                ),

                                const Gap(16),

                                // Notifications Setting (Placeholder)
                                _buildSettingCard(
                                  context,
                                  icon: FluentIcons.alert_24_regular,
                                  title: 'Notifications',
                                  subtitle:
                                      'Manage your notification preferences',
                                  trailing: Switch(
                                    value: true,
                                    onChanged: (value) {},
                                    activeColor: AppUtils.mainBlue(context),
                                  ),
                                ),

                                const Gap(16),

                                // Language Setting (Placeholder)
                                _buildSettingCard(
                                  context,
                                  icon: FluentIcons.local_language_24_regular,
                                  title: 'Language',
                                  subtitle: 'Choose your preferred language',
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'English',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppUtils.mainBlack(context),
                                          ),
                                        ),
                                        const Gap(8),
                                        Icon(
                                          FluentIcons.chevron_down_24_regular,
                                          size: 16,
                                          color: AppUtils.mainGrey(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Spacer(),

                                // Footer Section
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            FluentIcons.info_24_regular,
                                            size: 18,
                                            color: AppUtils.mainBlue(context),
                                          ),
                                          const Gap(8),
                                          Text(
                                            "Acknowledgment",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  AppUtils.mainBlack(context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(12),
                                      Text(
                                        "This platform was designed under the visionary leadership of Francis Flynn Chacha.",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppUtils.mainGrey(context),
                                          height: 1.5,
                                        ),
                                      ),
                                      const Gap(8),
                                      Row(
                                        children: [
                                          Text(
                                            "Powered by ",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppUtils.mainGrey(context),
                                            ),
                                          ),
                                          Text(
                                            "Labs",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppUtils.mainBlue(context),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Platform Details Sidebar
                        Expanded(
                          flex: 3,
                          child: PlatformDetails(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, Map<dynamic, dynamic> user, bool isNewActivities) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            "Settings",
            style: TextStyle(
              fontSize: 20,
              color: AppUtils.mainWhite(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            spacing: 8,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FluentIcons.alert_24_regular,
                      size: 24,
                      color: AppUtils.mainWhite(context),
                    ),
                  ),
                  if (isNewActivities)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppUtils.mainRed(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(8),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  user.isNotEmpty ? user['username'][0].toUpperCase() : 'G',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppUtils.mainBlue(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppUtils.mainBlack(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppUtils.mainGrey(context),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          trailing,
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppUtils.mainBlue(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    !isDark ? AppUtils.mainBlue(context) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FluentIcons.weather_sunny_24_filled,
                size: 16,
                color: !isDark ? Colors.white : AppUtils.mainGrey(context),
              ),
            ),
            const Gap(4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark ? AppUtils.mainBlue(context) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FluentIcons.weather_moon_24_filled,
                size: 16,
                color: isDark ? Colors.white : AppUtils.mainGrey(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
