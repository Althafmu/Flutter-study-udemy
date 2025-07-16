import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/models/categories_model.dart';
import 'package:meal_app/models/meals_model.dart';
import 'package:meal_app/screens/meals_screen.dart';
import 'package:meal_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<MealsModel> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(context, CategoriesModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MealsScreen(
              title: category.title,
              meals:
                  widget.availableMeals.where((meal) {
                    return meal.categories.contains(category.id);
                  }).toList(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (CategoriesModel categoriesModel in dummyCategories)
            CategoryGridItem(
              category: categoriesModel,
              selectCategory: () => _selectCategory(context, categoriesModel),
            ),
        ],
      ),
      builder:
          (context, child) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.3),
              end: const Offset(0, 0),
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          ),
    );
  }
}
