import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../models/responses/places_response.dart';

class LocationService {
  static LocationService? _instance;

  factory LocationService() {
    return _instance ??= LocationService._();
  }

  LocationService._();

  static const String _apiKey = 'AIzaSyDCkkGnM5MsciCvDYI7A_70Px-UiM3Ir8Q';

  Future<List<Place>> fetchNearbyClinics(String query) async {
    final uri = Uri.parse('https://places.googleapis.com/v1/places:searchText');
    final body = {'textQuery': query, 'maxResultCount': 3};
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': '*',
    };
    final response = await post(uri, body: jsonEncode(body), headers: headers);
    final jsonString = response.body;
    log('JSON: $jsonString');
    return PlacesResponse.fromJson(jsonDecode(jsonString)).places ?? [];
  }
}
