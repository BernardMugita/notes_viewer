import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/maktaba_app_bar/maktaba_app_bar.dart';

class LandingPageDesktop extends StatelessWidget {
  const LandingPageDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Bar
            MaktabaAppBar(),

            // Hero Section with Blue Gradient
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppUtils.mainBlue(context),
                    AppUtils.mainBlue(context).withOpacity(0.8),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WELCOME',
                            style: TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Arifu Library, a platform built by students for students.',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Powered by Labs',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          ElevatedButton(
                            onPressed: () => context.go('/login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppUtils.mainBlue(context),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48.0,
                                vertical: 20.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side - Logo
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: Image.asset(
                          'assets/images/alib-hd-shaddow.png', // Your jlib logo
                          height: 300,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // What You'll Find Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 80.0),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    "What You'll Find",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppUtils.mainBlack(context),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Everything you need to excel in your studies',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppUtils.mainGrey(context),
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.video_library,
                          title: 'Video Lectures',
                          description:
                              'Access recorded lectures and tutorials anytime, anywhere',
                          color: Colors.blue.shade100,
                          iconColor: AppUtils.mainBlue(context),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.note_alt,
                          title: 'Study Notes',
                          description:
                              'Upload and access comprehensive study materials',
                          color: Colors.pink.shade100,
                          iconColor: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.slideshow,
                          title: 'Presentations',
                          description:
                              'View and share course presentations and slides',
                          color: Colors.orange.shade100,
                          iconColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.groups,
                          title: 'Collaborative Learning',
                          description:
                              'Connect with fellow students and share knowledge',
                          color: Colors.green.shade100,
                          iconColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.dashboard,
                          title: 'Progress Tracking',
                          description:
                              'Monitor your learning journey with detailed analytics',
                          color: Colors.purple.shade100,
                          iconColor: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: FeatureCard(
                          icon: Icons.school,
                          title: 'Course Management',
                          description:
                              'Organize your units and materials efficiently',
                          color: Colors.teal.shade100,
                          iconColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Platform Preview Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 80.0),
              color: Colors.grey.shade50,
              child: Column(
                children: [
                  Text(
                    'Platform Preview',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppUtils.mainBlack(context),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'See what makes Arifu Library special',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppUtils.mainGrey(context),
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenshotCard(
                        title: 'Dashboard',
                        description:
                            'Track your progress and recent activities',
                        imagePath: 'assets/screenshots/dashboard.png',
                      ),
                      const SizedBox(width: 30),
                      ScreenshotCard(
                        title: 'Course Selection',
                        description: 'Choose from available courses seamlessly',
                        imagePath: 'assets/screenshots/courses.png',
                      ),
                      const SizedBox(width: 30),
                      ScreenshotCard(
                        title: 'Study Materials',
                        description: 'Access notes, videos, and presentations',
                        imagePath: 'assets/screenshots/materials.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Statistics Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60.0),
              decoration: BoxDecoration(
                color: AppUtils.mainBlue(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatCard(
                    icon: Icons.person,
                    value: '142+',
                    label: 'Registered Students',
                  ),
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  StatCard(
                    icon: Icons.note,
                    value: '5+',
                    label: 'Study Notes',
                  ),
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  StatCard(
                    icon: Icons.video_library,
                    value: '77+',
                    label: 'Video Recordings',
                  ),
                  Container(
                    height: 80,
                    width: 1,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  StatCard(
                    icon: Icons.slideshow,
                    value: '4+',
                    label: 'Presentations',
                  ),
                ],
              ),
            ),

            // Call to Action Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 80.0, horizontal: 80.0),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    'Ready to Get Started?',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppUtils.mainBlack(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Join hundreds of students already using Arifu Library',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppUtils.mainGrey(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppUtils.mainBlue(context),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () => context.go('/login'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppUtils.mainBlue(context),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          side: BorderSide(
                            color: AppUtils.mainBlue(context),
                            width: 2,
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(32.0),
              color: AppUtils.mainBlack(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/alib-hd-shaddow.png',
                        height: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Arifu Library',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'A platform built by students for students',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '© 2025 Arifu Library. All rights reserved. | Powered by Labs',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48.0,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenshotCard extends StatelessWidget {
  const ScreenshotCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppUtils.mainBlue(context), width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.screenshot,
                    size: 64,
                    color: AppUtils.mainBlue(context).withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppUtils.mainGrey(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 48,
          color: Colors.white,
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
