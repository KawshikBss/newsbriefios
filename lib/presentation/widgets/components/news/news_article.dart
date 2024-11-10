import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/articale_dialog.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/comments_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class NewsArticle extends StatefulWidget {
  ArticleModel? article;
  NewsArticle({super.key, this.article});

  @override
  State<NewsArticle> createState() => _NewsArticleState();
}

class _NewsArticleState extends State<NewsArticle> {
  ArticleModel? article;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String? _authToken;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  @override
  void initState() {
    super.initState();
    setState(() {
      article = widget.article;
    });
    tokenStorage.readString().then((value) {
      if (value.isNotEmpty) {
        setState(() {
          _authToken = value;
        });
      }
      updateReadNews(value);
    });
  }

  @override
  void didUpdateWidget(covariant NewsArticle oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      article = widget.article;
    });
  }

  void updateReadNews(String token) async {
    if (article!.id == null) return;
    await readNews(token, article!.id!);
  }

  void handleSaveNews() async {
    if (_authToken == null || article!.id == null) return;
    var res = await saveNews(_authToken!, article!.id!);
    if (res) {
      setState(() {
        article!.savedBookmark = !(article!.savedBookmark!);
      });
    }
  }

  void handleShareNews() async {
    if (_authToken == null || article!.id == null) return;
    Share.share('https://newsbriefapp.com/article/${article!.id}');
    var res = await shareNews(_authToken!, article!.id!);
    if (res) {
      setState(() {
        article!.shares = (article!.shares ?? 0) + 1;
      });
    }
  }

  void openArticale() {
    if (article == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticaleDialog(
          article: article!,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, style: BorderStyle.solid))),
      child: Column(
        children: [
          if (article!.images != null && article!.images!.isNotEmpty)
            Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: ((MediaQuery.of(context).size.width - 10) * 9) / 16,
                  ),
                  items: widget.article?.images?.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                            onPressed: openArticale,
                            icon: Container(
                              width: MediaQuery.of(context).size.width - 10,
                              height:
                                  ((MediaQuery.of(context).size.width - 10) *
                                          9) /
                                      16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
            ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: openArticale,
              child: Text(
                article?.title ?? 'Title',
                style: Theme.of(context).textTheme.titleMedium,
              )),
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: openArticale,
              child: RichText(
                text: TextSpan(
                  text: article?.summary ?? 'Summary', // First part of the text
                  style:
                      Theme.of(context).textTheme.titleSmall, // Main text style
                  children: [
                    TextSpan(
                      text:
                          ' ...${AppLocalizations.of(context)?.details ?? 'details'}', // Second part of the text
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF318EF8)),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 16,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            article?.timeNow ?? 'now',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Image.network(
                            article?.biasImage ?? '',
                            width: 40,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            article?.biasText ?? 'Neutral',
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _authToken != null
                              ? IconButton(
                                  iconSize: 20,
                                  onPressed: handleSaveNews,
                                  icon: Icon(article!.savedBookmark == true
                                      ? FontAwesomeIcons.solidBookmark
                                      : FontAwesomeIcons.bookmark))
                              : const SizedBox.shrink(),
                          IconButton(
                              onPressed: () {
                                if (article == null) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentsDialog(
                                      article: article!,
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
                                    '${article?.commentsCount ?? 0}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ],
                              )),
                          IconButton(
                              onPressed: handleShareNews,
                              icon: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      article!.shares! > 0
                                          ? FontAwesomeIcons.solidPaperPlane
                                          : FontAwesomeIcons.paperPlane,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '${article?.shares ?? 0}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                  ])),
                        ],
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
