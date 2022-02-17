import 'package:flutter/material.dart';

import '../viewmodels/place_view_model.dart';

class PlacesList extends StatelessWidget {
  final List<PlaceViewModel> places;
  Function(PlaceViewModel) onSelected;
  PlacesList({required this.places, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                onSelected(places[index]);
              },
              title: Text(places[index].name),
            ));
  }
}
