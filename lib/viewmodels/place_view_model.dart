import 'package:flutter_google_maps/models/place_model.dart';

class PlaceViewModel {
  PlaceModel _placeModel;

  PlaceViewModel(PlaceModel newPlaceModel) : _placeModel = newPlaceModel;

  double get lat => _placeModel.lat;

  String get placeId => _placeModel.placeId;

  String get name => _placeModel.name;

  double get lng => _placeModel.lng;
}
