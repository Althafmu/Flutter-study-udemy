import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:fav_place_app/model/place.dart';

Future<Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,adderess TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places =
        data
            .map(
              (e) => Place(
                id: e['id'] as String,
                title: e['title'] as String,
                image: File(e['image'] as String),
                location: PlaceLocation(
                  latitude: e['lat'] as double,
                  longitude: e['lng'] as double,
                  address: e['adderess'] as String,
                ),
              ),
            )
            .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filenmae = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filenmae');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'adderess': newPlace.location.address,
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
      (ref) => UserPlacesNotifier(),
    );
