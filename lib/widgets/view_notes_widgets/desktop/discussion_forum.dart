import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart'; // Added Gap import
import 'package:logger/logger.dart';
import 'package:maktaba/providers/auth_provider.dart'; // Added AuthProvider import
import 'package:maktaba/providers/comments_provider.dart'; // Added CommentsProvider import
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart'; // Added EmptyWidget import
import 'package:maktaba/utils/enums.dart'; // Added Enums import for EmptyWidgetType
import 'package:provider/provider.dart'; // Added Provider import
import 'package:jwt_decoder/jwt_decoder.dart'; // Added JwtDecoder import

class DiscussionForum extends StatefulWidget {
  final String studyMaterialId;

  const DiscussionForum({super.key, required this.studyMaterialId});

  @override
  State<DiscussionForum> createState() => _DiscussionForumState();
}

class _DiscussionForumState extends State<DiscussionForum> {
  final TextEditingController _commentController = TextEditingController();
  String _tokenRef = '';

  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tokenRef = context.read<AuthProvider>().token ?? '';
      if (_tokenRef.isNotEmpty) {
        context.read<CommentsProvider>().getCommentsByMaterial(
              token: _tokenRef,
              studyMaterialId: widget.studyMaterialId,
            );
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, CommentsProvider>(
      builder: (context, authProvider, commentsProvider, child) {
        logger.log(Level.info, commentsProvider.comments);

        if (commentsProvider.commentToEdit != null &&
            _commentController.text.isEmpty) {
          _commentController.text = commentsProvider.commentToEdit!['content'];
        }

        return Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppUtils.backgroundPanel(context),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: commentsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : commentsProvider.comments.isEmpty
                        ? const Center(
                            child: EmptyWidget(
                              errorHeading: "No Comments Yet!",
                              errorDescription:
                                  "Be the first to leave a comment.",
                              type: EmptyWidgetType.notes,
                            ),
                          )
                        : ListView.builder(
                            itemCount: commentsProvider.comments.length,
                            itemBuilder: (context, index) {
                              final comment = commentsProvider.comments[index];
                              return Forummessage(
                                username: comment['owner'] ?? 'Anonymous',
                                timestamp:
                                    AppUtils.formatDate(comment['created_at']),
                                content: comment['content'] ?? '',
                                comment: comment,
                                studyMaterialId: widget.studyMaterialId,
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: AppUtils.mainGrey(context)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: AppUtils.mainBlue(context)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: commentsProvider.isLoading
                      ? null
                      : () async {
                          if (_commentController.text.isNotEmpty) {
                            bool success;
                            if (commentsProvider.commentToEdit != null) {
                              // Editing existing comment
                              success = await commentsProvider.editComment(
                                token: _tokenRef,
                                commentId: commentsProvider.commentToEdit!['id'],
                                content: _commentController.text,
                              );
                              if (success) {
                                commentsProvider.setCommentToEdit(null);
                              }
                            } else {
                              // Creating new comment
                              success = await commentsProvider.createComment(
                                token: _tokenRef,
                                studyMaterialId: widget.studyMaterialId,
                                content: _commentController.text,
                              );
                            }
                            if (success) {
                              _commentController.clear();
                              // Refresh comments after create/edit
                              await commentsProvider.getCommentsByMaterial(
                                token: _tokenRef,
                                studyMaterialId: widget.studyMaterialId,
                              );
                            }
                          }
                        },
                  child: CircleAvatar(
                    backgroundColor: commentsProvider.isLoading
                        ? Colors.grey
                        : AppUtils.mainBlue(context),
                    child: commentsProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(FluentIcons.send_24_regular,
                            color: AppUtils.mainWhite(context)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Forummessage extends StatelessWidget {
  final String username;
  final String timestamp;
  final String content;
  final Map<String, dynamic> comment;
  final String studyMaterialId;

  const Forummessage({
    super.key,
    required this.username,
    required this.timestamp,
    required this.content,
    required this.comment,
    required this.studyMaterialId,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final commentsProvider =
        Provider.of<CommentsProvider>(context, listen: false);
    final decodedToken = JwtDecoder.decode(authProvider.token!);
    final currentUserId = decodedToken['user_id'];
    final isOwner = comment['user_id'] == currentUserId;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppUtils.backgroundPanel(context),
                child: Icon(
                  FluentIcons.person_24_regular,
                  color: AppUtils.mainBlack(context),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppUtils.mainGrey(context),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isOwner)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      commentsProvider.setCommentToEdit(comment);
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(
                          context, commentsProvider);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
          const Divider(),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, CommentsProvider commentsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(5),
            ),
            width: 300,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.delete_24_regular,
                  color: AppUtils.mainRed(context),
                  size: 80,
                ),
                const Gap(20),
                Text(
                  "Confirm Delete",
                  style: TextStyle(
                      fontSize: 18, color: AppUtils.mainRed(context)),
                ),
                const Text(
                  "Are you sure you want to delete this comment? Note that this action is irreversible.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                                EdgeInsets.all(10)),
                            backgroundColor: WidgetStatePropertyAll(
                                AppUtils.mainBlueAccent(context)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FluentIcons.dismiss_24_filled,
                                  color: AppUtils.mainRed(context)),
                              const Gap(5),
                              Text("Cancel",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppUtils.mainRed(context))),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: Consumer<CommentsProvider>(
                          builder: (context, commentsProvider, _) {
                            return ElevatedButton(
                              onPressed: commentsProvider.isLoading
                                  ? null
                                  : () async {
                                      Navigator.of(context).pop();
                                      await commentsProvider.deleteComment(
                                        token: Provider.of<AuthProvider>(
                                                context, listen: false)
                                            .token!,
                                        commentId: comment['id'],
                                        studyMaterialId: studyMaterialId,
                                      );
                                    },
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(10)),
                                backgroundColor: WidgetStatePropertyAll(
                                    AppUtils.mainRed(context)),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: commentsProvider.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(FluentIcons.delete_24_regular,
                                            color: AppUtils.mainWhite(context)),
                                        const Gap(5),
                                        Text("Delete",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppUtils.mainWhite(
                                                    context))),
                                      ],
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
