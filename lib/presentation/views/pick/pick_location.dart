import 'dart:convert';

import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:newsbriefapp/presentation/widgets/components/pick/location_item.dart';
import 'package:newsbriefapp/presentation/widgets/components/pick/location_search_field.dart';
import 'package:newsbriefapp/presentation/widgets/layouts/menu_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({super.key});

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  String? _authToken;
  AsyncStorageLocal userStorage = AsyncStorageLocal(keyFile: 'user');
  Map<String, dynamic> _userData = {};
  Map<String, dynamic>? _searchedLocation;
  List<dynamic> _savedLocations = [];

  void setSearchedLocation(Map<String, dynamic> location) {
    if (location.isEmpty) return;
    setState(() {
      _searchedLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();
    tokenStorage.readString().then((value) {
      if (value.isEmpty) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      _authToken = value;
      fetchUserLocations();
    });
    userStorage.readString().then((value) {
      if (value.isEmpty) return;
      setState(() {
        _userData = jsonDecode(value) as Map<String, dynamic>;
      });
    });
  }

  void fetchUserLocations() async {
    if (_authToken == null) return;
    var res = await getUserLocations(_authToken);
    if (res['success']) {
      setState(() {
        _savedLocations = res['locations'];
      });
    }
  }

  void refresh() async {
    fetchUserLocations();
    setState(() {
      _searchedLocation = null;
    });
    var userData = await getUser(_authToken);
    if (userData['success']) {
      setState(() {
        _userData = userData['user'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuLayout(
        child: Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LocationSearchField(
            setSearchedLocation: setSearchedLocation,
          ),
          Visibility(
            visible: _searchedLocation != null,
            child: Container(
              margin: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.locationsSearch ??
                        'Locations Search',
                    style: const TextStyle(
                        color: Color(0xFF0d6efd),
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  LocationItem(
                    icon: Icons.location_on,
                    location: _searchedLocation,
                    actionButtons: true,
                    refresh: refresh,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.primaryLocation ??
                      'Primary Location',
                  style: const TextStyle(
                      color: Color(0xFF0d6efd),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                LocationItem(
                  location: {
                    'city': _userData['city'],
                    'state': _userData['state'],
                    'country': _userData['country'],
                    'zip': _userData['zip'],
                  },
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.locationsYouFollow ??
                      'Locations you follow',
                  style: const TextStyle(
                      color: Color(0xFF0d6efd),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                _savedLocations.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)?.noLocationFound ??
                              'No location found',
                          style: const TextStyle(
                              color: Color(0xFF6c757d),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : Column(
                        children: [
                          for (var location in _savedLocations)
                            LocationItem(
                              icon: Icons.location_pin,
                              location: {
                                'id': location['id'],
                                'city': location['city'],
                                'state': location['state'],
                                'country': location['country'],
                                'zip': location['zip'],
                              },
                              removeButton: true,
                            )
                        ],
                      ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
