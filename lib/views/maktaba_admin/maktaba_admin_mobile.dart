import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/utils/app_utils.dart';

class MaktabaAdminMobile extends StatefulWidget {
  const MaktabaAdminMobile({super.key});

  @override
  State<MaktabaAdminMobile> createState() => _MaktabaAdminMobileState();
}

class _MaktabaAdminMobileState extends State<MaktabaAdminMobile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
      if (authProvider.token != null) {
        coursesProvider.getAllCourses(token: authProvider.token!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maktaba Admin - Mobile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Manager - Courses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppUtils.mainBlue(context),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<CoursesProvider>(
                builder: (context, coursesProvider, child) {
                  if (coursesProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (coursesProvider.courses.isEmpty) {
                    return const Center(child: Text('No courses found.'));
                  } else {
                    return ListView.builder(
                      itemCount: coursesProvider.courses.length,
                      itemBuilder: (context, index) {
                        final course = coursesProvider.courses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(course['title'] ?? 'No Title'),
                            subtitle: Text(course['description'] ?? 'No Description'),
                            trailing: Text('ID: ${course['id'] ?? 'N/A'}'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
