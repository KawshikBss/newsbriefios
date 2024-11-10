import 'package:async_storage_local/async_storage_local.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/domain/auth_requests.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationItem extends StatefulWidget {
  final IconData? icon;
  final Map<String, dynamic>? location;
  final bool actionButtons;
  final bool removeButton;
  final Function? refresh;

  const LocationItem(
      {super.key,
      this.icon,
      this.location,
      this.actionButtons = false,
      this.removeButton = false,
      this.refresh});

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  AsyncStorageLocal tokenStorage = AsyncStorageLocal(keyFile: 'token');
  String? _authToken;
  late Map<String, dynamic> location;

  @override
  void initState() {
    super.initState();
    tokenStorage.readString().then((value) {
      _authToken = value;
    });
    location = {
      'id': widget.location?['id'] ?? '',
      'city': widget.location?['city'] ?? '',
      'state': widget.location?['state'] ?? '',
      'country': widget.location?['country'] ?? '',
      'zip': widget.location?['zip'] ?? '',
    };
  }

  @override
  void didUpdateWidget(covariant LocationItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      location['id'] = widget.location?['id'] ?? '';
      location['city'] = widget.location?['city'] ?? '';
      location['state'] = widget.location?['state'] ?? '';
      location['country'] = widget.location?['country'] ?? '';
      location['zip'] = widget.location?['zip'] ?? '';
    });
  }

  void setAsPrimary() async {
    var res = await setUserLocation(_authToken, {
      'action': 'primary',
      'city': widget.location?['city'] ?? '',
      'state': widget.location?['state'] ?? '',
      'country': widget.location?['country'] ?? '',
      'zip': widget.location?['zip'] ?? ''
    });
    if (res) {
      if (widget.refresh != null) {
        widget.refresh!();
      }
    }
  }

  void addAsInterest() async {
    var res = await setUserLocation(_authToken, location);
    if (res) {
      if (widget.refresh != null) {
        widget.refresh!();
      }
    }
  }

  void remove() async {
    var res = await removeUserLocation(_authToken, location);
    if (res) {
      if (widget.refresh != null) {
        widget.refresh!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = location['city'];
    final state = location['state'];
    final country = location['country'];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Icon(widget.icon ?? FontAwesomeIcons.home),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (city.isNotEmpty || state.isNotEmpty || country.isNotEmpty)
                Text(
                  city.isNotEmpty
                      ? city
                      : state.isNotEmpty
                          ? state
                          : country,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (city.isNotEmpty || state.isNotEmpty || country.isNotEmpty)
                Text(
                  [
                    if (city.isNotEmpty) city,
                    if (state.isNotEmpty) state,
                    if (country.isNotEmpty) country,
                  ].join(', '),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6c757d),
                  ),
                ),
              if (widget.actionButtons)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: setAsPrimary,
                        child: Text(
                          AppLocalizations.of(context)?.setAsPrimary ??
                              'Set as primary',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF287efd),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 10,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: addAsInterest,
                        child: Text(
                          AppLocalizations.of(context)?.addAsInterest ??
                              'Add as interest',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF287efd),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (widget.removeButton)
                GestureDetector(
                  onTap: remove,
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFe04e5c),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
