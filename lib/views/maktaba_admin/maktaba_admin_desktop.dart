import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class MaktabaAdminDesktop extends StatefulWidget {
  const MaktabaAdminDesktop({super.key});

  @override
  State<MaktabaAdminDesktop> createState() => _MaktabaAdminDesktopState();
}

class _MaktabaAdminDesktopState extends State<MaktabaAdminDesktop> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Consumer<TogglesProvider>(
        builder: (BuildContext context, togglesProvider, _) {
          bool isMinimized = togglesProvider.isSideNavMinimized;

          return Flex(
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
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Column(
                      spacing: 20,
                      children: [
                        _buildTopBar(context),
                        _buildPageTitle(),
                        _buildStatsCards(),
                        _buildContentManagement()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppUtils.mainBlue(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.5),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 2,
                  ),
                ),
                filled: false,
                prefixIcon: Icon(
                  FluentIcons.search_24_regular,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search content...",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
              ),
            ),
          ),
          Spacer(),
          Row(
            spacing: 10,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.alert_24_regular,
                  size: 25,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.go('/settings');
                },
                icon: Icon(
                  FluentIcons.settings_24_regular,
                  size: 25,
                  color: AppUtils.mainWhite(context),
                ),
              ),
              Gap(10),
              CircleAvatar(
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  'AD',
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            'Manage your Arifu Library content',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return SizedBox(
      height: 145,
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: _buildStatCard(
              'Courses',
              '12',
              FluentIcons.book_24_regular,
              Colors.blue,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Units',
              '48',
              FluentIcons.notebook_24_regular,
              Colors.green,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Students',
              '256',
              FluentIcons.people_24_regular,
              Colors.orange,
            ),
          ),
          Expanded(
            child: _buildStatCard(
              'Lessons',
              '182',
              FluentIcons.class_24_regular,
              Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppUtils.mainGrey(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              IconButton(
                icon: Icon(FluentIcons.more_vertical_24_regular, size: 20),
                onPressed: () {},
                color: Colors.grey,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentManagement() {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppUtils.mainGrey(context)),
      ),
      child: Column(
        spacing: 20,
        children: [
          // Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Courses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddDialog();
                },
                icon: Icon(FluentIcons.add_24_regular),
                label: Text('Add Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtils.mainBlue(context),
                  foregroundColor: AppUtils.mainWhite(context),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          // Course List
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: _buildCourseList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    final courses = [
      {'name': 'Computer Science', 'units': '12', 'students': '85'},
      {'name': 'Business Administration', 'units': '10', 'students': '62'},
      {'name': 'Engineering', 'units': '15', 'students': '54'},
      {'name': 'Medicine', 'units': '18', 'students': '45'},
    ];

    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          // List Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Course Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Units',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Students',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(width: 100),
              ],
            ),
          ),
          // List Items
          ...courses.map((course) => _buildCourseItem(
                course['name']!,
                course['units']!,
                course['students']!,
              )),
        ],
      ),
    );
  }

  Widget _buildCourseItem(String name, String units, String students) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppUtils.mainGrey(context)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(units, style: TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Text(students, style: TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 5,
              children: [
                IconButton(
                  icon: Icon(FluentIcons.edit_24_regular, size: 20),
                  onPressed: () {
                    _showEditDialog(name);
                  },
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(FluentIcons.delete_24_regular, size: 20),
                  onPressed: () {
                    _showDeleteDialog(name);
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Course'),
        content: Text('Add new course dialog would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Course: $name'),
        content: Text('Edit course dialog would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Course'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
