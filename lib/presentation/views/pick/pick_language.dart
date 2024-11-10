import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/core/locale_provider.dart';
import 'package:newsbriefapp/data/language_model.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/pick/select_button.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/pick_layout.dart';
import 'package:provider/provider.dart';

class PickLanguage extends StatefulWidget {
  const PickLanguage({super.key});

  @override
  State<PickLanguage> createState() => _PickLanguageState();
}

class _PickLanguageState extends State<PickLanguage> {
  LanguageModel? _selectedLanguage = languageList.first;
  AsyncStorageLocal lang = AsyncStorageLocal(keyFile: 'lang');
  AsyncStorageLocal interestsStorage = AsyncStorageLocal(keyFile: 'interests');
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');

  @override
  void initState() {
    super.initState();
    lang.readString().then((value) {
      if (value.isEmpty || value.trim().isEmpty) {
        value = '{"name": "English", "code": "en"}';
      }
      var langData = jsonDecode(value);
      LanguageModel lang =
          LanguageModel(name: langData['name'], code: langData['code']);
      if (value.isNotEmpty) {
        LanguageModel found = languageList.firstWhere(
            (item) => item.code == lang.code || item.name == lang.name);
        setState(() {
          _selectedLanguage = found;
        });
      }
    });
  }

  void handleLanguageSelect(LanguageModel? lang) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedLanguage = lang;
      });
    });
  }

  void handleNextStep() async {
    if (_selectedLanguage != null) {
      lang.saveString(_selectedLanguage!.toString());
      var token = await tokenStorage.readString();
      await setUserLanguage(token, _selectedLanguage?.code ?? 'en');
      String languageCode = 'en';
      switch (_selectedLanguage?.code) {
        case 'cn':
          languageCode = 'zh';
          break;
        case 'jap':
          languageCode = 'ja';
          break;
        case 'kor':
          languageCode = 'ko';
          break;
        case 'spa':
          languageCode = 'es';
          break;
        case 'tc':
          languageCode = 'zh';
          break;
      }
      Provider.of<LocaleProvider>(context, listen: false)
          .setLocale(languageCode);
    }
    var res = await interestsStorage.readString();
    if (res.isEmpty) {
      Navigator.pushNamed(context, '/pick-interests');
    } else {
      Navigator.pushNamed(context, '/main');
    }
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
            Image.network(
              'https://newsbriefapp.com/assets/logo.jpg',
              height: 100,
              width: 100,
            ),
            ...languageList.asMap().entries.map((entry) {
              var index = entry.key;
              var language = entry.value;
              if (index % 2 == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectButton(
                      isActive: language == _selectedLanguage,
                      label: language.name,
                      onPressed: () => handleLanguageSelect(language),
                    ),
                    if (index + 1 < languageList.length)
                      SelectButton(
                        isActive: languageList[index + 1] == _selectedLanguage,
                        label: languageList[index + 1].name,
                        onPressed: () =>
                            handleLanguageSelect(languageList[index + 1]),
                      )
                  ],
                );
              }
              return const SizedBox.shrink();
            }).toList(),
            Container(
              margin: const EdgeInsets.only(top: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/main');
                    },
                    child: Text(
                      'Home',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: handleNextStep,
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
