import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:newsbriefapp/data/light_theme_data.dart';
import 'package:newsbriefapp/presentation/views/auth/login_page.dart';
import 'package:newsbriefapp/presentation/views/donation/donation_payment.dart';
import 'package:newsbriefapp/presentation/views/news/saved_news.dart';
import 'package:newsbriefapp/presentation/views/pick/pick_interests.dart';
import 'package:newsbriefapp/presentation/views/pick/pick_language.dart';
import 'package:newsbriefapp/presentation/views/pick/pick_location.dart';
import 'package:newsbriefapp/presentation/views/profile/edit_profile.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/main_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:newsbriefapp/core/locale_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51Q1mPBRrzj49tN1wZtrKa6p7EMNKtxKpY1xfDjlNEzZySKWbuS76nVW3Xu5zzxB6UfD9ne6IUaQi8Cckxp5cINGb00rGhgFPns';
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');
  String locale = 'en';
  @override
  void initState() {
    super.initState();
    loadLang();
  }

  void loadLang() async {
    String? locale = await langStorage.readString();
    if (locale.isEmpty || locale.trim().isEmpty) {
      locale = '{"name": "English", "code": "en"}';
    }
    var langData = jsonDecode(locale);
    Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(langData['code'] ?? 'en');
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [routeObserver],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: LightThemeData.themeData(),
      locale: localeProvider.locale,
      home: const MainLayout(),
      routes: <String, WidgetBuilder>{
        '/pick-language': (context) => const PickLanguage(),
        '/pick-interests': (context) => const PickInterests(),
        '/pick-location': (context) => const PickLocation(),
        '/login': (context) => const LoginPage(),
        '/trending-news': (context) => const MainLayout(currentIndex: 1),
        '/donate-info': (context) => const MainLayout(currentIndex: 2),
        '/profile': (context) => const MainLayout(currentIndex: 3),
        '/edit-profile': (context) => const EditProfile(),
        '/main': (context) => const MainLayout(),
        '/donate': (context) => const DonationPayment(),
        '/saved-news': (context) => const SavedNews(),
      },
    );
  }
}
