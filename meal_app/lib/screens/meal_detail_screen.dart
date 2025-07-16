import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/models/meals_model.dart';
import 'package:meal_app/widgets/meal_item.dart';
import 'package:meal_app/provider/favorites_provider.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({super.key, required this.meal});

  final MealsModel meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoritesMealsProvider);

    final isFavorite = favoriteMeals.contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              final wasAdded = ref
                  .read(favoritesMealsProvider.notifier)
                  .toggleFavoriteMealStatus(meal);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded
                        ? 'meal was added to favorites'
                        : 'meal was removed from favorites',
                  ),
                ),
              );
            },
            icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                );
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border_outlined,
                key: ValueKey(isFavorite),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          MealItem(meal: meal),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                for (String ingredient in meal.ingredients)
                  Text(ingredient, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
                Text(
                  'Steps',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                for (String step in meal.steps)
                  Text(step, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
