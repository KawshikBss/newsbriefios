import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentReply extends StatefulWidget {
  final int newsId;
  final int? parentId;
  final Function? refresh;
  const CommentReply(
      {super.key, required this.newsId, this.parentId, this.refresh});

  @override
  State<CommentReply> createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  final TextEditingController _controller = TextEditingController();
  String? _authToken;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  void handleSubmit() async {
    if (_authToken == null || _controller.text.isEmpty) return;
    var res = await sendReply(
        _authToken!, widget.newsId, widget.parentId, _controller.text);
    if (res) {
      _controller.clear();
      widget.refresh!();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    tokenStorage.readString().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _authToken = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.parentId != null
                          ? AppLocalizations.of(context)?.reply ?? 'Reply'
                          : AppLocalizations.of(context)?.comment ?? 'Comment',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                _authToken != null
                    ? Column(
                        children: [
                          TextField(
                            controller: _controller,
                            maxLines: 8,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFFdee2e6), width: 1),
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: handleSubmit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.solidPaperPlane,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)?.submit ??
                                          'Submit',
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
                          )
                        ],
                      )
                    : Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.signInToComment ??
                                      'Please Sign in to ${widget.parentId != null ? 'Reply' : AppLocalizations.of(context)?.comment ?? 'Comment'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0d6efd),
                                  ),
                                ))
                          ]))
              ],
            ),
          );
        });
  }
}
