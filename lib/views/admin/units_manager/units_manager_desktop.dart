import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/courses_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/units_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class UnitsManagerDesktop extends StatefulWidget {
  final String courseId;
  const UnitsManagerDesktop({super.key, required this.courseId});

  @override
  State<UnitsManagerDesktop> createState() => _UnitsManagerDesktopState();
}

class _UnitsManagerDesktopState extends State<UnitsManagerDesktop> {
  final TextEditingController _searchController = TextEditingController();
  Logger logger = Logger();

  String tokenRef = '';
  String unitId = '';

  String selectedCourseId = '';
  String selectedSemester = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<UnitsProvider>().getUnitsByCourse(tokenRef, widget.courseId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUtils.backgroundPanel(context),
      body: Consumer3<TogglesProvider, AuthProvider, UnitsProvider>(
        builder: (BuildContext context, togglesProvider, authProvider,
            unitsProvider, _) {
          bool isMinimized = togglesProvider.isSideNavMinimized;

          return authProvider.isLoading || unitsProvider.isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Lottie.asset("assets/animations/maktaba_loader.json"),
                )
              : Flex(
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
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1,
                              top: 20,
                              bottom: 20),
                          child: Column(
                            children: [
                              _buildTopBar(context),
                              const Gap(20),
                              Expanded(
                                child: _buildUnitsSection(),
                              )
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
        borderRadius: BorderRadius.circular(8),
        color: AppUtils.mainBlue(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              FluentIcons.arrow_left_24_regular,
              color: AppUtils.mainWhite(context),
              size: 24,
            ),
            tooltip: 'Back to Courses',
          ),
          const Gap(12),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppUtils.mainWhite(context)),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppUtils.mainWhite(context),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppUtils.mainWhite(context).withOpacity(0.1),
                prefixIcon: Icon(
                  FluentIcons.search_24_regular,
                  color: AppUtils.mainWhite(context).withOpacity(0.8),
                ),
                hintText: "Search units...",
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: AppUtils.mainWhite(context).withOpacity(0.7),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FluentIcons.alert_24_regular,
                  size: 24,
                  color: AppUtils.mainWhite(context),
                ),
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
              const Gap(8),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainWhite(context),
                child: Text(
                  'AD',
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

  Widget _buildUnitsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Units',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Manage course units',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddUnitDialog();
                },
                icon: const Icon(FluentIcons.add_24_regular, size: 20),
                label: const Text('Add Unit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppUtils.mainBlue(context),
                  foregroundColor: AppUtils.mainWhite(context),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(child: _buildUnitsList()),
        ],
      ),
    );
  }

  Widget _buildUnitsList() {
    return Consumer<UnitsProvider>(
      builder: (context, unitsProvider, _) {
        if (unitsProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (unitsProvider.units.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Icon(
                    FluentIcons.notebook_24_regular,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                  const Gap(16),
                  Text(
                    'No units available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Get started by adding your first unit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Gap(8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddUnitDialog();
                    },
                    icon: const Icon(FluentIcons.add_24_regular),
                    label: const Text('Add your first unit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUtils.mainBlue(context),
                      foregroundColor: AppUtils.mainWhite(context),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: unitsProvider.units.asMap().entries.map((entry) {
              return _buildUnitItem(entry.value, entry.key);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildUnitItem(dynamic unit, int index) {
    final name = unit['name'] as String? ?? 'N/A';
    final description = unit['code'] as String? ?? 'No description';

    return Container(
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppUtils.mainGrey(context).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          context.go(
              '/maktaba_admin/units_manager/${widget.courseId}/lessons_manager/${unit['id']}');
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            FluentIcons.notebook_24_regular,
            color: Colors.green,
            size: 28,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(FluentIcons.edit_24_regular, size: 20),
              onPressed: () {
                // _showEditUnitDialog(unit, index);
              },
              color: Colors.blue,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(FluentIcons.delete_24_regular, size: 20),
              onPressed: () {
                unitId = unit['id'];
                // _showDeleteUnitDialog(index);
              },
              color: Colors.red,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUnitDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _codeController = TextEditingController();
    final _semesterController = TextEditingController();
    final _selectedCourseId = widget.courseId;
    final _courseIdController = TextEditingController();
    final courses = context.watch<CoursesProvider>().courses;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final semesters = context.read<UnitsProvider>().semesters;

        return Consumer<TogglesProvider>(
            builder: (context, togglesProvider, _) {
          return Stack(
            children: [
              AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  padding: const EdgeInsets.all(28),
                  width: MediaQuery.of(context).size.width * 0.35,
                  constraints: BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: AppUtils.mainWhite(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Unit",
                              style: TextStyle(
                                fontSize: 22,
                                color: AppUtils.mainBlue(context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: const Icon(FluentIcons.dismiss_24_regular),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // Unit Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(FluentIcons.class_24_regular),
                            labelText: 'Unit Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppUtils.mainBlue(context),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a unit name'
                              : null,
                        ),
                        const Gap(16),

                        // Unit Code
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                                FluentIcons.number_circle_0_24_regular),
                            labelText: 'Unit Code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 212, 212, 212),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: AppUtils.mainBlue(context),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter a unit code'
                              : null,
                        ),
                        const Gap(16),



                        // Semester Dropdown
                        Column(
                          children: [
                            TextFormField(
                              controller: _semesterController,
                              readOnly: true,
                              onTap: () {
                                togglesProvider.toggleSemesterDropDown();
                              },
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(FluentIcons.calendar_24_regular),
                                labelText: 'Semester',
                                suffixIcon: Icon(
                                  togglesProvider.showSemesterDropDown
                                      ? FluentIcons.chevron_up_24_regular
                                      : FluentIcons.chevron_down_24_regular,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 212, 212, 212),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppUtils.mainBlue(context),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Please select a semester'
                                  : null,
                            ),
                            if (togglesProvider.showSemesterDropDown)
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppUtils.mainWhite(context),
                                  border: Border.all(
                                    color: AppUtils.mainGrey(context)
                                        .withOpacity(0.3),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: semesters.map<Widget>((semester) {
                                    final isSelected =
                                        selectedSemester == semester;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedSemester = semester;
                                          _semesterController.text = semester;
                                        });
                                        togglesProvider
                                            .toggleSemesterDropDown();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: isSelected
                                              ? AppUtils.mainBlue(context)
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppUtils.mainBlue(context)
                                                : AppUtils.mainGrey(context)
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          semester,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected
                                                ? Colors.white
                                                : AppUtils.mainBlack(context),
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                        const Gap(24),

                        // Submit Button
                        Consumer<UnitsProvider>(
                            builder: (context, unitProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: unitProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success =
                                            await unitProvider.addUnit(
                                          tokenRef,
                                          _nameController.text,
                                          'anat.png',
                                          _codeController.text,
                                          widget.courseId,
                                          [],
                                          [],
                                          _semesterController.text,
                                        );
                                        if (success) {
                                          Navigator.of(dialogContext).pop();
                                        }
                                      }
                                    },
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                backgroundColor: WidgetStatePropertyAll(
                                  unitProvider.isLoading
                                      ? Colors.grey
                                      : AppUtils.mainBlue(context),
                                ),
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                ),
                              ),
                              child: unitProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Add Unit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              if (context.watch<UnitsProvider>().success)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SuccessWidget(
                      message: context.watch<UnitsProvider>().message),
                )
              else if (context.watch<UnitsProvider>().error)
                Positioned(
                  top: 20,
                  right: 20,
                  child: FailedWidget(
                      message: context.watch<UnitsProvider>().message),
                )
            ],
          );
        });
      },
    );
  }

// void _showEditUnitDialog(dynamic unit, int index) {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController =
//       TextEditingController(text: unit['unit_name'] as String?);
//   final _descriptionController =
//       TextEditingController(text: unit['unit_code'] as String?);
//
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.all(0),
//         content: Container(
//           padding: const EdgeInsets.all(28),
//           width: MediaQuery.of(context).size.width * 0.4,
//           constraints: const BoxConstraints(maxWidth: 500),
//           decoration: BoxDecoration(
//             color: AppUtils.mainWhite(context),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Edit Unit",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: AppUtils.mainBlue(context),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(),
//                       icon: const Icon(FluentIcons.dismiss_24_regular),
//                     ),
//                   ],
//                 ),
//                 const Gap(24),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(FluentIcons.notebook_24_regular),
//                     labelText: 'Unit Name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                         color: Color.fromARGB(255, 212, 212, 212),
//                       ),
//                     ),
//                     focusColor: AppUtils.mainBlue(context),
//                   ),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a unit name' : null,
//                 ),
//                 const Gap(16),
//                 TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(
//                         FluentIcons.text_description_24_regular),
//                     labelText: 'Unit Code',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                         color: Color.fromARGB(255, 212, 212, 212),
//                       ),
//                     ),
//                     focusColor: AppUtils.mainBlue(context),
//                   ),
//                   validator: (value) =>
//                       value!.isEmpty ? 'Please enter a unit code' : null,
//                 ),
//                 const Gap(24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState!.validate()) {
//                         context.read<UnitsProvider>().updateUnit(
//                             token: tokenRef,
//                             unitId: unit['id'],
//                             unitName: _nameController.text,
//                             unitCode: _descriptionController.text);
//                         Navigator.of(dialogContext).pop();
//                       }
//                     },
//                     style: ButtonStyle(
//                       shape: WidgetStatePropertyAll(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       backgroundColor: WidgetStatePropertyAll(
//                         AppUtils.mainBlue(context),
//                       ),
//                       padding: const WidgetStatePropertyAll(
//                         EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                       ),
//                     ),
//                     child: Text(
//                       'Save Changes',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: AppUtils.mainWhite(context),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// void _showDeleteUnitDialog(int index) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.all(0),
//         content: Container(
//           padding: const EdgeInsets.all(28),
//           decoration: BoxDecoration(
//             color: AppUtils.mainWhite(context),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           width: MediaQuery.of(context).size.width * 0.4,
//           constraints: const BoxConstraints(maxWidth: 450),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppUtils.mainRed(context).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   FluentIcons.delete_24_regular,
//                   color: AppUtils.mainRed(context),
//                   size: 48,
//                 ),
//               ),
//               const Gap(20),
//               Text(
//                 "Delete Unit",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: AppUtils.mainRed(context),
//                 ),
//               ),
//               const Gap(12),
//               const Text(
//                 "Are you sure you want to delete this unit? This action cannot be undone.",
//                 style: TextStyle(fontSize: 15),
//                 textAlign: TextAlign.center,
//               ),
//               const Gap(28),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         Navigator.of(dialogContext).pop();
//                       },
//                       style: ButtonStyle(
//                         padding: const WidgetStatePropertyAll(
//                           EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         side: WidgetStatePropertyAll(
//                           BorderSide(color: AppUtils.mainGrey(context)),
//                         ),
//                         shape: WidgetStatePropertyAll(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppUtils.mainBlack(context),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Gap(12),
//                   Expanded(
//                     child: Consumer<UnitsProvider>(
//                       builder: (context, unitsProvider, _) {
//                         return ElevatedButton(
//                           onPressed: unitsProvider.isLoading
//                               ? null
//                               : () async {
//                                   await unitsProvider.deleteUnit(
//                                       token: tokenRef, unitId: unitId);
//                                   Navigator.of(dialogContext).pop();
//                                 },
//                           style: ButtonStyle(
//                             padding: const WidgetStatePropertyAll(
//                               EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             backgroundColor: WidgetStatePropertyAll(
//                               unitsProvider.isLoading
//                                   ? Colors.grey
//                                   : AppUtils.mainRed(context),
//                             ),
//                             shape: WidgetStatePropertyAll(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                           child: unitsProvider.isLoading
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 2.5,
//                                   ),
//                                 )
//                               : Text(
//                                   "Delete",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: AppUtils.mainWhite(context),
//                                   ),
//                                 ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
}
