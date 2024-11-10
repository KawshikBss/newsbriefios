import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:newsbriefapp/data/language_model.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/preloader.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/news_article.dart';

class TrendingNews extends StatefulWidget {
  const TrendingNews({super.key});

  @override
  State<TrendingNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<TrendingNews> {
  final scrollController = ScrollController();
  int _nextPage = 1;
  List<ArticleModel> _newsList = [];
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetch();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetch();
      }
    });
  }

  void fetch() async {
    setState(() {
      _loading = true;
    });
    String? authToken = await tokenStorage.readString();
    String? locale = await langStorage.readString();
    var langData = jsonDecode(locale);
    LanguageModel lang =
        LanguageModel(name: langData['name'], code: langData['code']);
    var result = await getTrendingNews(
        token: authToken, page: _nextPage, lang: lang.code);
    if (!mounted) return;
    setState(() {
      _nextPage = result['next-page'] ?? _nextPage;
      _newsList.addAll(result['data'] ?? []);
      _loading = false;
    });
  }

  void refresh() async {
    setState(() {
      _loading = true;
    });
    String? authToken = await tokenStorage.readString();
    var result = await getTrendingNews(token: authToken);
    if (!mounted) return;
    setState(() {
      _nextPage = result['next-page'] ?? _nextPage;
      _newsList.addAll(result['data'] ?? []);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Column(
          children: [
            if (_newsList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _newsList.length,
                  itemBuilder: (context, index) {
                    if (index < _newsList.length) {
                      ArticleModel article = _newsList[index];
                      return NewsArticle(
                        article: article,
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            if (_loading) const Preloader()
          ],
        ),
        onRefresh: () async {
          refresh();
        });
  }
}
