import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/viewmodels/place_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/web_service.dart';

class PlaceListViewModel extends ChangeNotifier {
  List<PlaceViewModel> places = List<PlaceViewModel>.empty(growable: true);
  MapType mapType = MapType.normal;

  Future<void> fetchNearPlaces(String keyword, double lat, double lng) async {
    var response = await WebServices().fetchNearbePlaces(keyword, lat, lng);
    places = response.map((e) => PlaceViewModel(e)).toList();
    print("got result: ${places.length}");
    notifyListeners();
  }

  void toggleMapType() {
    mapType == MapType.normal
        ? mapType = MapType.satellite
        : mapType = MapType.normal;

    notifyListeners();
  }
}
