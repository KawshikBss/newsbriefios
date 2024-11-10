import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/drawer_menu_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawerMenu extends StatefulWidget implements PreferredSizeWidget {
  const CustomDrawerMenu({super.key});

  @override
  State<StatefulWidget> createState() => _CustomAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<StatefulWidget> {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  String? _email;

  void changeRoute(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void handleLogout() {
    tokenStorage.delete();
    userStorage.delete();
    Navigator.pushNamed(context, '/main');
  }

  @override
  void initState() {
    super.initState();
    userStorage.readString().then((value) {
      if (value.isEmpty) return;
      var data = jsonDecode(value) as Map<String, dynamic>;
      setState(() {
        _email = data['email'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Aligning the close icon button at the top right
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).closeDrawer();
                },
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          ListTile(
            title: DrawerMenuItem(
              icon: FontAwesomeIcons.locationDot,
              title: AppLocalizations.of(context)?.locations ?? 'Locations',
              subTitle: AppLocalizations.of(context)?.locationPreferences ??
                  'Pick your default city or add more locations.',
            ),
            onTap: () {
              changeRoute('/pick-location');
            },
          ),
          ListTile(
            title: DrawerMenuItem(
              icon: FontAwesomeIcons.bell,
              title: AppLocalizations.of(context)?.notifications ??
                  'Notifications',
              subTitle:
                  AppLocalizations.of(context)?.notificationsPreferences ??
                      'Choose what and how often to get alerted.',
            ),
            onTap: () {},
          ),
          ListTile(
            title: DrawerMenuItem(
              icon: FontAwesomeIcons.shieldHalved,
              title: AppLocalizations.of(context)?.privacyPolicy ??
                  'Privacy Policy',
              // subTitle: 'Change your privacy settings.',
            ),
            onTap: () async {
              Uri url =
                  Uri.parse('https://newsbriefapp.com/page/privacy-policy');
              await launchUrl(url, mode: LaunchMode.inAppWebView);
            },
          ),
          ListTile(
            title: DrawerMenuItem(
              icon: FontAwesomeIcons.globe,
              title: AppLocalizations.of(context)?.language ?? 'Language',
            ),
            onTap: () {
              changeRoute('/pick-language');
            },
          ),
          const SizedBox(
            height: 48,
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.contactUs ?? 'Contact us',
            ),
            onTap: () async {
              Uri url = Uri.parse('https://newsbriefapp.com/page/contact-us');
              await launchUrl(url, mode: LaunchMode.inAppWebView);
            },
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.termsOfUse ?? 'Terms of use',
            ),
            onTap: () async {
              Uri url = Uri.parse(
                  'https://newsbriefapp.com/page/newsbrief-terms-of-use');
              await launchUrl(url, mode: LaunchMode.inAppWebView);
            },
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.helpCenter ?? 'Help center',
            ),
            onTap: () async {
              Uri url = Uri.parse('https://newsbriefapp.com/page/help-center');
              await launchUrl(url, mode: LaunchMode.inAppWebView);
            },
          ),
          ListTile(
            title: DrawerMenuItem(
              title:
                  AppLocalizations.of(context)?.recommendToFriendsAndFamily ??
                      'Recommend to friends & family',
            ),
            onTap: () {},
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.rateApp ?? 'Rate app',
            ),
            onTap: () {},
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.aboutUs ?? 'About Us',
            ),
            onTap: () {},
          ),
          ListTile(
            title: DrawerMenuItem(
              title: AppLocalizations.of(context)?.logOut ?? 'Logout',
              subTitle: _email ?? '',
              borderBottom: false,
            ),
            onTap: handleLogout,
          ),
        ],
      ),
    );
  }
}
