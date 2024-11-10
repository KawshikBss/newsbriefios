import 'package:async_storage_local/async_storage_local.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/comments_dialog.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/dialog_layout.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticaleDialog extends StatefulWidget {
  final ArticleModel article;
  const ArticaleDialog({super.key, required this.article});

  @override
  State<ArticaleDialog> createState() => _ArticaleDialogState();
}

class _ArticaleDialogState extends State<ArticaleDialog> {
  ArticleModel? _article;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String? _authToken;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  @override
  void initState() {
    super.initState();
    _article = widget.article;
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
    return DialogLayout(
        title: const Text('News'),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 32,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                      child: Column(
                    children: [
                      _article!.images != null && _article!.images!.length > 1
                          ? Stack(
                              children: [
                                CarouselSlider(
                                  carouselController: _carouselController,
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    height:
                                        ((MediaQuery.of(context).size.width -
                                                    10) *
                                                9) /
                                            16,
                                  ),
                                  items: _article?.images?.map((imageUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              10,
                                          height: ((MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      10) *
                                                  9) /
                                              16,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                    onPressed: () {
                                      _carouselController.previousPage();
                                    },
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  bottom: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios,
                                        color: Colors.white),
                                    onPressed: () {
                                      _carouselController.nextPage();
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width - 10,
                              height:
                                  ((MediaQuery.of(context).size.width - 10) *
                                          9) /
                                      16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(_article
                                                  ?.images?.isNotEmpty ==
                                              true
                                          ? _article?.images?.first ??
                                              'https://ircsan.com/wp-content/uploads/2024/03/placeholder-image.png'
                                          : 'https://ircsan.com/wp-content/uploads/2024/03/placeholder-image.png'),
                                      fit: BoxFit.cover)),
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        _article?.title ?? 'Title',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HtmlWidget(
                        _article?.detailedSummary ?? 'Summary',
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _authToken != null
                              ? IconButton(
                                  iconSize: 20,
                                  onPressed: () {},
                                  icon: Icon(_article!.savedBookmark == true
                                      ? FontAwesomeIcons.solidBookmark
                                      : FontAwesomeIcons.bookmark))
                              : const SizedBox.shrink(),
                          IconButton(
                              onPressed: () {
                                if (_article == null) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsDialog(
                                      article: _article!,
                                    ), // Your full-page modal widget
                                    fullscreenDialog:
                                        true, // Opens the page as a modal with a close button
                                  ),
                                );
                              },
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.comment,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${_article?.commentsCount ?? 0}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ],
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      _article!.shares! > 0
                                          ? FontAwesomeIcons.solidPaperPlane
                                          : FontAwesomeIcons.paperPlane,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '${_article?.shares ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                  ])),
                        ],
                      ),
                      const Divider(),
                      Table(
                        children: [
                          TableRow(children: [
                            Text(
                              'Credibility score',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 16),
                            ),
                            Text(
                              _article?.credibilityScore ?? 'Not available',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            )
                          ])
                        ],
                      ),
                      const Divider(),
                      Table(
                        children: [
                          TableRow(children: [
                            Text(
                              'Media Bias',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 16),
                            ),
                            Text(
                              _article?.mediaBias ?? 'Neutral',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                            )
                          ])
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ))));
        }));
  }
}
