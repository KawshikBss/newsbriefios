import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/data/comment_model.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/comment_reply.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final Function? refresh;
  const CommentItem({super.key, required this.comment, this.refresh});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  CommentModel? _comment;
  bool _showReplies = false;
  String? _authToken;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  void toggleShowReplies() {
    bool showTmp = _showReplies;
    setState(() {
      _showReplies = !showTmp;
    });
  }

  void redirectToLogin() {
    if (_authToken == null || _authToken!.isEmpty) {
      Navigator.pushNamed(context, '/login');
      return;
    }
  }

  void updateCommentVote(int voteType) async {
    redirectToLogin();
    if (_authToken == null || _comment!.id == null) return;
    var response =
        await voteComment(_authToken!, _comment!.id!, voteType: voteType);
    if (response) {
      widget.refresh!();
    }
  }

  void handleSaveComment() async {
    redirectToLogin();
    if (_authToken == null || _comment!.id == null) return;
    var response = await saveComment(_authToken!, _comment!.id!);
    if (response) {
      widget.refresh!();
    }
  }

  void handleReportComment() async {
    redirectToLogin();
    if (_authToken == null || _comment!.id == null) return;
    var response = await reportComment(_authToken!, _comment!.id!);
    if (response) {
      widget.refresh!();
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      handleSaveComment();
                      setState(() {
                        _comment!.saved = !(_comment!.saved!);
                      });
                    },
                    icon: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _comment!.saved!
                            ? const Color(0xFF0d6efd)
                            : Colors.white,
                        border: _comment!.saved! ? null : Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.bookBookmark,
                            color:
                                _comment!.saved! ? Colors.white : Colors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _comment?.saveText ?? 'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: _comment!.saved!
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      handleReportComment();
                      setState(() {
                        _comment!.reported = !(_comment!.reported!);
                      }); // Update the state of the dialog
                    },
                    icon: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: _comment!.reported!
                            ? const Color(0xFFdc3545)
                            : Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.circleExclamation,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _comment?.reportText ?? 'Report',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _comment = widget.comment;
    });
    tokenStorage.readString().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _authToken = value;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CommentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _comment = widget.comment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide.none,
          left: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                  image: NetworkImage(_comment?.ownerAvatar ??
                      'https://ircsan.com/wp-content/uploads/2024/03/placeholder-image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
                width: 8), // Add some space between avatar and content
            // Comment Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_comment?.ownerName ?? '',
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(_comment?.timeNow ?? '',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  // Comment text, wrapped to prevent overflow
                  Text(
                    _comment?.comment ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: null, // Allows the text to take multiple lines
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Add spacing between comment and actions
        // Action buttons row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enables horizontal scrolling
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CommentReply(
                          newsId: _comment!.newsId!,
                          parentId: _comment!.id!,
                          refresh: widget.refresh,
                        );
                      });
                },
                iconSize: 16,
                icon: Row(
                  children: [
                    const Icon(FontAwesomeIcons.comment),
                    Text(
                      _comment?.replyText ?? ' Reply',
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () => updateCommentVote(1),
                iconSize: 16,
                icon: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.arrowUp,
                      color: (_comment?.upvotesCount ?? 0) > 0
                          ? const Color(0xFF3bd4f2)
                          : Colors.black,
                    ),
                    Text(
                      '${_comment?.upvotesCount ?? '0'}',
                      style: TextStyle(
                          fontSize: 16,
                          color: (_comment?.upvotesCount ?? 0) > 0
                              ? const Color(0xFF3bd4f2)
                              : Colors.black),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () => updateCommentVote(0),
                iconSize: 16,
                icon: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.arrowDown,
                      color: (_comment?.downvotesCount ?? 0) > 0
                          ? const Color(0xFF3bd4f2)
                          : Colors.black,
                    ),
                    Text('${_comment?.downvotesCount ?? '0'}',
                        style: TextStyle(
                            fontSize: 16,
                            color: (_comment?.downvotesCount ?? 0) > 0
                                ? const Color(0xFF3bd4f2)
                                : Colors.black)),
                  ],
                ),
              ),
              IconButton(
                onPressed: toggleShowReplies,
                iconSize: 16,
                icon: Row(
                  children: [
                    Text(
                      '${_comment?.repliesCount ?? '0'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      _comment?.commentsText ?? ' Comments',
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _dialogBuilder(context),
                iconSize: 16,
                icon: const Icon(FontAwesomeIcons.ellipsis),
              ),
            ],
          ),
        ),
        _showReplies
            ? Column(
                children: [
                  for (var comment in _comment!.replies!)
                    CommentItem(
                      comment: comment,
                      refresh: widget.refresh,
                    )
                ],
              )
            : const SizedBox.shrink(),
      ]),
    );
  }
}
