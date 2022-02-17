import 'dart:convert';

import 'package:flutter_google_maps/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../models/place_model.dart';

class WebServices {
  Future<List<PlaceModel>> fetchNearbePlaces(
      String keyword, double lat, double lng) async {
    final response = await http.get(Uri.parse(Utils.getURL(keyword, lat, lng)));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result['results'];
      return list.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception("Request failed with status: ${response.statusCode}.");
    }
  }
}
