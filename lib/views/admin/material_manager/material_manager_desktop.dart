import 'package:file_picker/file_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/lessons_provider.dart';
import 'package:maktaba/providers/toggles_provider.dart';
import 'package:maktaba/providers/uploads_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:maktaba/widgets/app_widgets/navigation/side_navigation.dart';
import 'package:provider/provider.dart';

class MaterialManagerDesktop extends StatefulWidget {
  final String lessonId;

  const MaterialManagerDesktop({super.key, required this.lessonId});

  @override
  State<MaterialManagerDesktop> createState() => _MaterialManagerDesktopState();
}

class _MaterialManagerDesktopState extends State<MaterialManagerDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String tokenRef = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = context.read<AuthProvider>().token;
      if (token != null) {
        tokenRef = token;
        context.read<LessonsProvider>().getLesson(tokenRef, widget.lessonId);
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
      body: Consumer3<TogglesProvider, AuthProvider, LessonsProvider>(
        builder: (BuildContext context, togglesProvider, authProvider,
            lessonsProvider, _) {
          bool isMinimized = togglesProvider.isSideNavMinimized;

          return authProvider.isLoading || lessonsProvider.isLoading
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
                                child: _buildMaterialsSection(),
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
            tooltip: 'Back to Lessons',
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
                hintText: "Search materials...",
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

  Widget _buildMaterialsSection() {
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
                    'Study Materials',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    'Manage lesson materials',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showUploadDialog();
                },
                icon: const Icon(FluentIcons.arrow_upload_24_regular, size: 20),
                label: const Text('Upload Material'),
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
          Expanded(child: _buildMaterialsList()),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return Consumer<LessonsProvider>(
      builder: (context, lessonsProvider, _) {
        if (lessonsProvider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final lesson = lessonsProvider.lesson;
        final materials = lesson['materials'] as List<dynamic>?;

        Logger logger = Logger();
        logger.d('Materials: $lesson');

        if (materials == null || materials.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Icon(
                    FluentIcons.document_multiple_24_regular,
                    color: Colors.grey[400],
                    size: 64,
                  ),
                  const Gap(16),
                  Text(
                    'No materials available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Get started by uploading your first material',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Gap(8),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showUploadDialog();
                    },
                    icon: const Icon(FluentIcons.arrow_upload_24_regular),
                    label: const Text('Upload your first material'),
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

        List<Widget> materialWidgets = [];
        if (materials != null) {
          final groupedMaterials = <String, List<dynamic>>{};
          for (var material in materials) {
            final type = material['type'] as String;
            if (!groupedMaterials.containsKey(type)) {
              groupedMaterials[type] = [];
            }
            groupedMaterials[type]!.add(material);
          }

          groupedMaterials.forEach((category, materialList) {
            materialWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainGrey(context),
                  ),
                ),
              ),
            );
            materialWidgets.addAll(
              materialList.map<Widget>((material) {
                return _buildMaterialItem(
                    material as Map<String, dynamic>, category);
              }).toList(),
            );
          });
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: materialWidgets,
          ),
        );
      },
    );
  }

  Widget _buildMaterialItem(Map<String, dynamic> material, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(
          _getIconForCategory(category),
          color: AppUtils.mainBlue(context),
        ),
        title: Text(
          material['name'] as String,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(FluentIcons.delete_24_regular, size: 20),
          onPressed: () {
            _showDeleteDialog(material['id'] as String);
          },
          color: Colors.red,
          tooltip: 'Delete',
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'notes':
        return FluentIcons.document_24_regular;
      case 'slides':
        return FluentIcons.slide_layout_24_regular;
      case 'recordings':
        return FluentIcons.video_24_regular;
      case 'contributions':
        return FluentIcons.people_24_regular;
      default:
        return FluentIcons.document_24_regular;
    }
  }

  void _showUploadDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _uploadTypeController = TextEditingController();
    PlatformFile? selectedFile;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upload Material",
                        style: TextStyle(
                          fontSize: 22,
                          color: AppUtils.mainBlue(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(FluentIcons.dismiss_24_regular),
                      ),
                    ],
                  ),
                  const Gap(24),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null) {
                        selectedFile = result.files.first;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppUtils.mainGrey(context).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FluentIcons.arrow_upload_24_regular,
                              color: AppUtils.mainBlue(context)),
                          const Gap(10),
                          Text(
                            'Select File',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppUtils.mainBlue(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'File Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a file name' : null,
                  ),
                  const Gap(16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const Gap(16),
                  DropdownButtonFormField<String>(
                    items: ['notes', 'slides', 'recordings', 'contributions']
                        .map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      _uploadTypeController.text = newValue!;
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const Gap(24),
                  Consumer<UploadsProvider>(
                    builder: (context, uploadsProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: uploadsProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate() &&
                                      selectedFile != null) {
                                    final Map<String, String> form = {
                                      'name': _nameController.text,
                                      'lesson_id': widget.lessonId,
                                      'unit_id': GoRouter.of(context)
                                          .state!
                                          .pathParameters['unitId']!,
                                      'description':
                                          _descriptionController.text,
                                      'type': _uploadTypeController.text,
                                    };
                                    final success =
                                        await uploadsProvider.uploadNewFile(
                                      tokenRef,
                                      selectedFile!,
                                      form,
                                    );
                                    if (success) {
                                      context
                                          .read<LessonsProvider>()
                                          .getLesson(tokenRef, widget.lessonId);
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
                              uploadsProvider.isLoading
                                  ? Colors.grey
                                  : AppUtils.mainBlue(context),
                            ),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                            ),
                          ),
                          child: uploadsProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'Upload',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String materialId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        Logger logger = Logger();
        logger.d('Deleting material: $materialId');
        return AlertDialog(
          title: Text('Delete Material'),
          content: Text('Are you sure you want to delete this material?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
            ),
            Consumer<UploadsProvider>(
              builder: (context, uploadsProvider, child) {
                return TextButton(
                  onPressed: uploadsProvider.isLoading
                      ? null
                      : () async {
                          final request = await uploadsProvider
                              .deleteUploadedMaterial(tokenRef, materialId);
                          if (request["status"] == "success") {
                            context
                                .read<LessonsProvider>()
                                .getLesson(tokenRef, widget.lessonId);
                            Navigator.of(dialogContext).pop();
                          }
                        },
                  child: uploadsProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text('Delete', style: TextStyle(color: Colors.red)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
