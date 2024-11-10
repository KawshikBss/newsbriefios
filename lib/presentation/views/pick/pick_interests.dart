import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/category_model.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/pick/select_button.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/pick_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickInterests extends StatefulWidget {
  const PickInterests({super.key});

  @override
  State<PickInterests> createState() => _PickInterestsState();
}

class _PickInterestsState extends State<PickInterests> {
  List<CategoryModel> _categoryList = [];
  List<dynamic> _selectedCategories = [];
  AsyncStorageLocal interestsStorage = AsyncStorageLocal(keyFile: 'interests');
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');

  @override
  void initState() {
    super.initState();
    fetchInterests();
    interestsStorage.readString().then((value) {
      if (value.isEmpty) return;
      List<dynamic> savedCategories = jsonDecode(value);

      setState(() {
        if (savedCategories.isEmpty) {
          preSelectInterests();
        } else {
          _selectedCategories = savedCategories;
        }
      });
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
      setState(() {
        _categoryList = res['data'];
      });
    }
  }

  void preSelectInterests() async {
    var res = await getAllInterests();
    if (res['success']) {
      List<CategoryModel> categoryList = res['data'];
      setState(() {
        _selectedCategories = categoryList.map((item) => item.id).toList();
      });
    }
  }

  void handleCategorySelect(CategoryModel? cat) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<int> tmpList = List.from(_selectedCategories);
      if (tmpList.any((selectedCat) => selectedCat == cat?.id)) {
        tmpList.removeWhere((selectedCat) => selectedCat == cat?.id);
      } else if (cat != null) {
        tmpList.add(cat.id!);
      }
      setState(() {
        _selectedCategories = tmpList;
      });
    });
  }

  void handleNextStep() async {
    if (_selectedCategories.isNotEmpty) {
      interestsStorage.saveString(jsonEncode(_selectedCategories));
      var token = await tokenStorage.readString();
      if (token.isNotEmpty) {
        await setUserInterests(token, _selectedCategories);
      }
    } else {
      interestsStorage.saveString('[]');
    }
    Navigator.pushNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return PickLayout(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: handleNextStep,
                    child: Text(
                      AppLocalizations.of(context)
                              ?.whatNewsAreYouInterestedIn ??
                          'What news are you interested in?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            ..._categoryList.asMap().entries.map((entry) {
              var index = entry.key;
              var category = entry.value;
              if (index % 2 == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectButton(
                      isActive: _selectedCategories
                          .any((selectedCat) => selectedCat == category.id),
                      label: category.name,
                      showSymbol: true,
                      onPressed: () => handleCategorySelect(category),
                    ),
                    if (index + 1 < _categoryList.length)
                      SelectButton(
                        isActive: _selectedCategories.any((selectedCat) =>
                            selectedCat == _categoryList[index + 1].id),
                        label: _categoryList[index + 1].name,
                        showSymbol: true,
                        onPressed: () =>
                            handleCategorySelect(_categoryList[index + 1]),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            Container(
              margin: const EdgeInsets.only(top: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: handleNextStep,
                    child: Text(
                      _selectedCategories.isEmpty
                          ? AppLocalizations.of(context)?.notNow ?? 'Not Now'
                          : AppLocalizations.of(context)?.next ?? 'Next',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
