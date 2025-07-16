import 'dart:io';

import 'package:fav_place_app/model/place.dart';
import 'package:fav_place_app/provider/user_places.dart';
import 'package:fav_place_app/views/widgets/image_input.dart';
import 'package:fav_place_app/views/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredText = _titleController.text;
    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredText, _selectedImage!, _selectedLocation!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Place")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            ImageInput(onPickimage: (image) => _selectedImage = image),
            SizedBox(height: 10),
            LocationInput(
              getLocation: (location) {
                _selectedLocation = location;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _savePlace(),
              icon: const Icon(Icons.add),
              label: const Text("Add Place"),
            ),
          ],
        ),
      ),
    );
  }
}
