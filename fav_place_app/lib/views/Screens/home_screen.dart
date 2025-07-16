import 'package:fav_place_app/provider/user_places.dart';
import 'package:fav_place_app/views/widgets/add_place.dart';
import 'package:fav_place_app/views/widgets/place_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _fetchPlaces;

  @override
  void initState() {
    super.initState();
    _fetchPlaces = ref.read(userPlacesProvider.notifier).loadPlaces();
    ;
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddPlace();
                  },
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _fetchPlaces,
          builder:
              (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : PlaceList(places: userPlaces),
        ),
      ),
    );
  }
}
