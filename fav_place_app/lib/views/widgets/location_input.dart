import 'dart:convert';

import 'package:fav_place_app/model/place.dart';
import 'package:fav_place_app/views/Screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.getLocation});
  final void Function(PlaceLocation location) getLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCw2wWtVvBbJBqvmNXLgBLoNOoOobA7R2s',
    );
    final respnse = await http.get(url);
    final respdata = json.decode(respnse.body);
    final address = respdata['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });
    widget.getLocation(_pickedLocation!);
  }

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCw2wWtVvBbJBqvmNXLgBLoNOoOobA7R2s';
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    if (pickedLocation == null) {
      return;
    }
    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "no Location Selected",
      textAlign: TextAlign.center,
      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: Text("Current Location"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {
                _selectOnMap();
              },
              label: Text("Select on Map"),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
