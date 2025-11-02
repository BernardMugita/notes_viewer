import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:logger/logger.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/providers/comments_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:maktaba/widgets/app_widgets/alert_widgets/empty_widget.dart';
import 'package:maktaba/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
            // Comments List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: commentsProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppUtils.mainBlue(context),
                        ),
                      )
                    : commentsProvider.comments.isEmpty
                        ? Center(
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
                              return ForumMessage(
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
            const Gap(16),

            // Comment Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(
                        color: AppUtils.mainGrey(context),
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppUtils.mainBlue(context),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  decoration: BoxDecoration(
                    color: commentsProvider.isLoading
                        ? Colors.grey
                        : AppUtils.mainBlue(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: commentsProvider.isLoading
                        ? null
                        : () async {
                            if (_commentController.text.isNotEmpty) {
                              bool success;
                              if (commentsProvider.commentToEdit != null) {
                                success = await commentsProvider.editComment(
                                  token: _tokenRef,
                                  commentId:
                                      commentsProvider.commentToEdit!['id'],
                                  content: _commentController.text,
                                );
                                if (success) {
                                  commentsProvider.setCommentToEdit(null);
                                }
                              } else {
                                success = await commentsProvider.createComment(
                                  token: _tokenRef,
                                  studyMaterialId: widget.studyMaterialId,
                                  content: _commentController.text,
                                );
                              }
                              if (success) {
                                _commentController.clear();
                                await commentsProvider.getCommentsByMaterial(
                                  token: _tokenRef,
                                  studyMaterialId: widget.studyMaterialId,
                                );
                              }
                            }
                          },
                    icon: commentsProvider.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            FluentIcons.send_24_filled,
                            color: Colors.white,
                            size: 20,
                          ),
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

class ForumMessage extends StatelessWidget {
  final String username;
  final String timestamp;
  final String content;
  final Map<String, dynamic> comment;
  final String studyMaterialId;

  const ForumMessage({
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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppUtils.mainWhite(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppUtils.mainBlue(context).withOpacity(0.1),
                child: Text(
                  username[0].toUpperCase(),
                  style: TextStyle(
                    color: AppUtils.mainBlue(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppUtils.mainBlack(context),
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppUtils.mainGrey(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwner)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      FluentIcons.more_vertical_24_regular,
                      size: 18,
                      color: AppUtils.mainGrey(context),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        commentsProvider.setCommentToEdit(comment);
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(
                            context, commentsProvider);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(FluentIcons.edit_24_regular,
                                size: 18, color: AppUtils.mainBlue(context)),
                            const Gap(12),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(FluentIcons.delete_24_regular,
                                size: 18, color: AppUtils.mainRed(context)),
                            const Gap(12),
                            const Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Gap(12),
          Divider(height: 1, color: Colors.grey.shade200),
          const Gap(12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppUtils.mainBlack(context),
              height: 1.5,
            ),
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Container(
            padding: const EdgeInsets.all(28),
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: AppUtils.mainWhite(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppUtils.mainRed(context).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FluentIcons.delete_24_regular,
                    color: AppUtils.mainRed(context),
                    size: 48,
                  ),
                ),
                const Gap(20),
                Text(
                  "Delete Comment",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.mainBlack(context),
                  ),
                ),
                const Gap(12),
                Text(
                  "Are you sure you want to delete this comment? This action cannot be undone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppUtils.mainGrey(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: AppUtils.mainGrey(context)),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 15,
                            color: AppUtils.mainBlack(context),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Consumer<CommentsProvider>(
                        builder: (context, commentsProvider, _) {
                          return ElevatedButton(
                            onPressed: commentsProvider.isLoading
                                ? null
                                : () async {
                                    Navigator.of(context).pop();
                                    await commentsProvider.deleteComment(
                                      token: Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .token!,
                                      commentId: comment['id'],
                                      studyMaterialId: studyMaterialId,
                                    );
                                  },
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 16),
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                AppUtils.mainRed(context),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            child: commentsProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Delete",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
