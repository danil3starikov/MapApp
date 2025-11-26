import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:atlas/atlas.dart';
import 'package:map_app/network/place_autocomplete_response.dart';

class ApiKeys {
  static const String mapsApiKey = String.fromEnvironment(
    'MAPS_API_KEY',
    defaultValue: '',
  );

  void validate() {
    if (mapsApiKey.isEmpty) {
      throw Exception(
        'MAPS_API_KEY is not defined. Please set it in the environment variables and run flutter with --dart-define=MAPS_API_KEY=<your_api_key>',
      );
    }
  }
}

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
  try {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      debugPrint('HTTP Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Network Error: $e');
    return null;
  }
}

  static Future<LatLng?> fetchPlaceDetails(String placeId) async {
    ApiKeys().validate();
    try {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/details/json',
        {'place_id': placeId, 'key': ApiKeys.mapsApiKey, 'fields': 'geometry'},
      );

      String? response = await NetworkUtility.fetchUrl(uri);
      if (response != null) {
        final json = jsonDecode(response);
        final lat = json['result']['geometry']['location']['lat'];
        final lng = json['result']['geometry']['location']['lng'];

        return LatLng(latitude: lat, longitude: lng);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching place details: $e');
      return null;
    }
  }

  static Future<List<AutocompletePrediction>?> fetchSuggestions(
    String query,
    bool isStart,
  ) async {
    ApiKeys().validate();
    try {
      Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json',
        {'input': query, 'key': ApiKeys.mapsApiKey},
      );
      String? response = await NetworkUtility.fetchUrl(uri);
      if (response != null) {
        PlaceAutocompleteResponse result =
            PlaceAutocompleteResponse.parseAutocompleteResult(response);
        if (result.predictions != null) {
          return result.predictions!;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      return null;
    }
  }
}
