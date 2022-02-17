class PlaceModel {
  double lat;
  double lng;
  String name;
  String placeId;

  PlaceModel(
      {required this.lat,
      required this.lng,
      required this.name,
      required this.placeId});
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    var location = json["geometry"]["location"];
    return PlaceModel(
        lat: location["lat"],
        lng: location["lng"],
        name: json["name"],
        placeId: json["place_id"]);
  }
}
