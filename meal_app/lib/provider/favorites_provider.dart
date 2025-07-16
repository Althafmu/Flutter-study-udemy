import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meals_model.dart';

class FavoritesMealsrNotifier extends StateNotifier<List<MealsModel>> {
  FavoritesMealsrNotifier(super.state);

  bool toggleFavoriteMealStatus(MealsModel meal) {
    final favoriteMeal = state.contains(meal);
    if (favoriteMeal) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favoritesMealsProvider =
    StateNotifierProvider<FavoritesMealsrNotifier, List<MealsModel>>((ref) {
      return FavoritesMealsrNotifier([]);
    });
