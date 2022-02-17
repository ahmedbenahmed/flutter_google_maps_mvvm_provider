import 'package:flutter/material.dart';
import 'package:flutter_google_maps/viewmodels/place_list_view_model.dart';
import 'package:flutter_google_maps/widgets/places_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:map_launcher/map_launcher.dart' as prefix0;
import '../viewmodels/place_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    _currentPosition = await _determinePosition();
    mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition.latitude, _currentPosition.longitude)));
  }

  Future<void> _openMapsFor(PlaceViewModel vm) async {
    if (await MapLauncher.isMapAvailable(prefix0.MapType.google) != null) {
      await MapLauncher.launchMap(
          mapType: prefix0.MapType.google,
          coords: Coords(vm.lat, vm.lng),
          title: vm.name,
          description: vm.name);
    } else if (await MapLauncher.isMapAvailable(prefix0.MapType.apple) !=
        null) {
      await MapLauncher.launchMap(
          mapType: prefix0.MapType.apple,
          coords: Coords(vm.lat, vm.lng),
          title: vm.name,
          description: vm.name);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    print(position);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<PlaceListViewModel>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: vm.mapType,
              markers: _getMarkers(vm),
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "Type Text Here",
                  filled: true,
                  fillColor: Colors.white),
              onSubmitted: (value) {
                vm.fetchNearPlaces(value, _currentPosition.latitude,
                    _currentPosition.longitude);
              },
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: FloatingActionButton(
                child: Icon(Icons.map),
                onPressed: () {
                  vm.toggleMapType();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.view_list),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => PlacesList(
                      places: vm.places,
                      onSelected: _openMapsFor,
                    ));
          },
        ),
      ),
    );
  }

  Set<Marker> _getMarkers(PlaceListViewModel vm) {
    return vm.places
        .map((place) => Marker(
              markerId: MarkerId(place.placeId),
              position: LatLng(place.lat, place.lng),
              infoWindow: InfoWindow(
                title: place.name,
              ),
            ))
        .toSet();
  }
}
