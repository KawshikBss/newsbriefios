import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:newsbriefapp/data/category_model.dart';
import 'package:newsbriefapp/data/language_model.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/preloader.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/news_article.dart';

class AllNews extends StatefulWidget {
  const AllNews({super.key});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');
  List<CategoryModel> _categoryList = [];
  List<dynamic> _selectedCategories = [];
  AsyncStorageLocal interestsStorage = AsyncStorageLocal(keyFile: 'interests');
  final scrollController = ScrollController();
  int _nextPage = 1;
  List<ArticleModel> _newsList = [];
  bool _loading = true;
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  @override
  void initState() {
    super.initState();
    fetch();
    fetchInterests();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetch();
      }
    });
    interestsStorage.readString().then((value) {
      if (value.isEmpty) return;
      List<dynamic> savedCategories = jsonDecode(value);
      setState(() {
        _selectedCategories = savedCategories;
      });
    });
  }

  void fetch() async {
    setState(() {
      _loading = true;
    });
    String? locale = await langStorage.readString();
    if (locale.isEmpty || locale.trim().isEmpty) {
      locale = '{"name": "English", "code": "en"}';
    }
    var langData = jsonDecode(locale);
    LanguageModel lang =
        LanguageModel(name: langData['name'], code: langData['code']);
    String? authToken = await tokenStorage.readString();
    var result =
        await getAllNews(token: authToken, page: _nextPage, lang: lang.code);
    if (!mounted) return;
    setState(() {
      _nextPage = result['next-page'] ?? _nextPage;
      _newsList.addAll(result['data'] ?? []);
      _loading = false;
    });
  }

  void fetchInterests() async {
    String? locale = await langStorage.readString();
    if (locale.isEmpty || locale.trim().isEmpty) {
      locale = '{"name": "English", "code": "en"}';
    }
    var langData = jsonDecode(locale);
    var res = await getAllInterests(lang: langData['code']);
    if (res['success']) {
      List<CategoryModel> fetchedCategories = res['data'];
      if (!mounted) return;
      setState(() {
        _categoryList = fetchedCategories;
        _selectedCategories = _selectedCategories
            .where((selectedCategory) => fetchedCategories
                .any((category) => category.id == selectedCategory))
            .toList();
      });
    }
  }

  void refresh() async {
    setState(() {
      _loading = true;
    });
    String? authToken = await tokenStorage.readString();
    var result = await getAllNews(token: authToken);
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
      onRefresh: () async {
        refresh();
      },
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pick-interests');
                    },
                    icon: const Icon(Icons.add)),
                for (var category in _categoryList)
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/pick-interests');
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        color: _selectedCategories.contains(category.id)
                            ? Colors.black
                            : Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      alignment: Alignment.center,
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: _selectedCategories.contains(category.id)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_newsList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _newsList.length,
                itemBuilder: (context, index) {
                  if (index < _newsList.length) {
                    ArticleModel article = _newsList[index];
                    return NewsArticle(article: article);
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
    );
  }
}
