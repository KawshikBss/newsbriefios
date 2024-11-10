import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _CustomAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<StatefulWidget> {
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  String? _userCountry;

  @override
  void initState() {
    super.initState();
    userStorage.readString().then((value) {
      if (value.isEmpty) return;
      var data = jsonDecode(value) as Map<String, dynamic>;
      setState(() {
        _userCountry = data['country'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      _userCountry != null && _userCountry!.isNotEmpty
                          ? '/pick-location'
                          : '/login');
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.black,
                    ),
                    Text(' ${_userCountry ?? 'United States'}')
                  ],
                )),
            Image.network(
              'https://newsbriefapp.com/assets/logo.jpg',
              height: 45,
              width: 45,
            ),
          ],
        ),
      ),
    );
  }
}
