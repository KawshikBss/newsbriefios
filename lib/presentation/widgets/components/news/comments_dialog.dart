import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:newsbriefapp/data/comment_model.dart';
import 'package:newsbriefapp/data/language_model.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/preloader.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/comment_item.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/comment_reply.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/dialog_layout.dart';

class CommentsDialog extends StatefulWidget {
  final ArticleModel article;
  const CommentsDialog({super.key, required this.article});

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  List<CommentModel> _commentsList = [];
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    String? authToken = await tokenStorage.readString();
    String? locale = await langStorage.readString();
    var langData = jsonDecode(locale);
    LanguageModel lang =
        LanguageModel(name: langData['name'], code: langData['code']);
    if (widget.article.id == null) return;
    var response =
        await getComments(authToken, widget.article.id!, lang: lang.code);
    setState(() {
      _commentsList = response['data'] ?? [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      title: const Icon(FontAwesomeIcons.comments),
      child: Stack(
        children: [
          if (loading) const Preloader(),
          ListView.builder(
            itemCount: _commentsList.length,
            itemBuilder: (context, index) {
              CommentModel comment = _commentsList[index];
              return CommentItem(comment: comment, refresh: fetch);
            },
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return CommentReply(
                      newsId: widget.article.id!,
                      refresh: fetch,
                    );
                  },
                );
              },
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
