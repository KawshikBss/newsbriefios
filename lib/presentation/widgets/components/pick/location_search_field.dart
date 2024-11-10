import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationSearchField extends StatefulWidget {
  final Function? setSearchedLocation;
  const LocationSearchField({super.key, this.setSearchedLocation});

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _controller = TextEditingController();
  final String googleAPIKey = "AIzaSyBthPBitQj--9rIBfHf5sXm8LWwN5gRbFk";

  Future<List<dynamic>> fetchPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleAPIKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result']['address_components'];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: GooglePlaceAutoCompleteTextField(
              boxDecoration: const BoxDecoration(color: Colors.transparent),
              textEditingController: _controller,
              googleAPIKey: googleAPIKey,
              inputDecoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.searchByCity ??
                      'Search by city',
                  border: InputBorder.none),
              debounceTime: 800,
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              itemClick: (Prediction prediction) async {
                _controller.text = prediction.description ?? '';
                _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: prediction.description!.length));
                Map<String, dynamic> placeData = {};
                final placeDetails =
                    await fetchPlaceDetails(prediction.placeId!);
                for (var component in placeDetails) {
                  var componentType = component['types']?.isNotEmpty
                      ? component['types'][0]
                      : null;
                  if (componentType != null) {
                    switch (componentType) {
                      case 'locality':
                        placeData['city'] = component['long_name'];
                        break;
                      case 'administrative_area_level_1':
                        placeData['state'] = component['long_name'];
                        break;
                      case 'country':
                        placeData['country'] = component['long_name'];
                        break;
                      case 'postal_code':
                        placeData['zip'] = component['long_name'];
                        break;
                    }
                  }
                }
                if (widget.setSearchedLocation == null) return;
                widget.setSearchedLocation!(placeData);
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(child: Text(prediction.description ?? ""))
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(),
              isCrossBtnShown: true,
              containerHorizontalPadding: 10,
              placeType: PlaceType.cities,
            ),
          )
        ],
      ),
    );
  }
}
