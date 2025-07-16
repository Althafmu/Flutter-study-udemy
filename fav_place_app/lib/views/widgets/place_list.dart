import 'package:fav_place_app/model/place.dart';
import 'package:fav_place_app/views/Screens/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatelessWidget {
  PlaceList({super.key, required this.places});

  final List<Place> places;
  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) return const Center(child: Text("No places added yet"));
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            places[index].location.address,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailsscreen(place: places[index]),
              ),
            );
          },
        );
      },
    );
  }
}
