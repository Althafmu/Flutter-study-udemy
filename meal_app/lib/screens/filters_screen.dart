import 'package:flutter/material.dart';
import 'package:meal_app/provider/filters_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltersScreen extends ConsumerWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = ref.watch(filtersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Filters')),

      body: Column(
        children: [
          SwitchListTile(
            value: activeFilters[Filter.glutenFree]!,
            onChanged: (value) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.glutenFree, value);
            },
            title: const Text('Gluten Free'),
            subtitle: const Text('Only include gluten free meals.'),
            activeColor: Theme.of(context).colorScheme.tertiary,
          ),
          SwitchListTile(
            value: activeFilters[Filter.lactoseFree]!,
            onChanged: (value) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.lactoseFree, value);
            },
            title: const Text('Lactose Free'),
            subtitle: const Text('Only include lactose free meals.'),
            activeColor: Theme.of(context).colorScheme.tertiary,
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegan]!,
            onChanged: (value) {
              ref.read(filtersProvider.notifier).setFilter(Filter.vegan, value);
            },
            title: const Text('Vegan'),
            subtitle: const Text('Only include vegan meals.'),
            activeColor: Theme.of(context).colorScheme.tertiary,
          ),
          SwitchListTile(
            value: activeFilters[Filter.vegetarian]!,
            onChanged: (value) {
              ref
                  .read(filtersProvider.notifier)
                  .setFilter(Filter.vegetarian, value);
            },
            title: const Text('Vegetarian'),
            subtitle: const Text('Only include vegetarian meals.'),
            activeColor: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
