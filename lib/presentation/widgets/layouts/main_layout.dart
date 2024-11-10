import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/data/nav_data.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_app_bar.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_bottom_navigation.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_drawer_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  final int currentIndex;
  const MainLayout({super.key, this.currentIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  AsyncStorageLocal langStorage = AsyncStorageLocal(keyFile: 'lang');
  AsyncStorageLocal interestsStorage = AsyncStorageLocal(keyFile: 'interests');

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    langStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushNamed(context, '/pick-language');
        return;
      }
    });
    interestsStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushNamed(context, '/pick-interests');
        return;
      }
    });
  }

  void handleTabChange(value) {
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentRoute = navList[_currentIndex];
    return Scaffold(
      appBar: currentRoute.navBarType != NavBarType.normal
          ? AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              title: Builder(builder: (context) {
                return currentRoute.navBarType == NavBarType.title
                    ? Center(
                        child: Text(currentRoute.name == 'Donate'
                            ? AppLocalizations.of(context)?.donate ?? 'Donate'
                            : currentRoute.name),
                      )
                    : currentRoute.navBarType == NavBarType.menu
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: const Icon(Icons.menu)),
                          )
                        : Text(currentRoute.name);
              }),
            )
          : const CustomAppBar(),
      body: Column(
        children: [
          Expanded(
            child: currentRoute.route,
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
          currentTabIndex: _currentIndex, handleTabChange: handleTabChange),
      drawer: const CustomDrawerMenu(),
    );
  }
}
