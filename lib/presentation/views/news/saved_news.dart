import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/article_model.dart';
import 'package:newsbriefapp/data/language_model.dart';
import 'package:newsbriefapp/domain/news_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_bottom_navigation.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_drawer_menu.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/preloader.dart';
import 'package:newsbriefapp/presentation/widgets/components/news/news_article.dart';

class SavedNews extends StatefulWidget {
  const SavedNews({super.key});

  @override
  State<SavedNews> createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');
  List<ArticleModel> _newsList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    tokenStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
    });
    fetch();
  }

  void fetch() async {
    setState(() {
      _loading = true;
    });
    String? locale = await langStorage.readString();
    // print('locale ${locale.trim().isEmpty}');
    if (locale.isEmpty || locale.trim().isEmpty) {
      locale = '{"name": "English", "code": "en"}';
    }
    var langData = jsonDecode(locale);
    LanguageModel lang =
        LanguageModel(name: langData['name'], code: langData['code']);
    String? authToken = await tokenStorage.readString();
    var result = await getSavedNews(token: authToken, lang: lang.code);
    setState(() {
      _newsList = result;
    });
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Builder(builder: (context) {
          return Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          );
        }),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                fetch(); // Refresh data on pull down
              },
              child: _loading
                  ? const Center(child: Preloader())
                  : _newsList.isNotEmpty
                      ? ListView.builder(
                          itemCount: _newsList.length,
                          itemBuilder: (context, index) {
                            ArticleModel article = _newsList[index];
                            return NewsArticle(article: article);
                          },
                        )
                      : const Center(
                          child: Text('No saved news available'),
                        ),
            ),
          ),
        ],
      ),
      drawer: const CustomDrawerMenu(),
      bottomNavigationBar: CustomBottomNavigation(
          currentTabIndex: 3,
          handleTabChange: (value) {
            Navigator.pushNamed(
                context,
                value == 1
                    ? '/trending-news'
                    : value == 2
                        ? '/donate-info'
                        : value == 3
                            ? '/profile'
                            : '/main');
          }),
    );
  }
}
