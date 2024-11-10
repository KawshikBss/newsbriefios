import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  State<MainProfile> createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> with RouteAware {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  Map<String, dynamic> _userData = {};
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    tokenStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      fetchUser(value);
    });
    userStorage.readString().then((value) {
      if (value.isEmpty) return;
      setState(() {
        _userData = jsonDecode(value) as Map<String, dynamic>;
      });
    });
  }

  void fetchUser(String token) async {
    var userData = await getUser(token);
    if (userData['success']) {
      setState(() {
        _userData = userData['user'];
      });
    }
  }

  @override
  void didPop() {
    super.didPop();
    _loadUser();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(200),
                        image: DecorationImage(
                          image: NetworkImage(
                            _userData['avatar'] != null &&
                                    _userData['avatar']!.isNotEmpty
                                ? 'https://newsbriefbucket.s3.us-east-2.amazonaws.com/${_userData['avatar']}'
                                : 'https://ircsan.com/wp-content/uploads/2024/03/placeholder-image.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.penToSquare,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userData['username'] ?? 'Username',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_userData['email'] != null)
                        Text(
                          _userData['email'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6c757d)),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (_userData['city'] != null)
                        Text(
                          _userData['city'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6c757d)),
                        ),
                      if (_userData['city'] != null ||
                          _userData['state'] != null ||
                          _userData['country'] != null)
                        Text(
                          '${_userData['city'] ?? ''}, ${_userData['state'] ?? ''}, ${_userData['country'] ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6c757d)),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/saved-news');
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: const Color(0xFFdee2e6)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_border_outlined),
                  Text(
                    AppLocalizations.of(context)?.saved ?? 'Saved',
                    // style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
