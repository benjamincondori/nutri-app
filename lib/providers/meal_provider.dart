import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/models/meal_detail.dart';

import '../models/meal.dart';

// Proveedor para manejar una única comida
// final selectedMealProvider = StateProvider<Meal?>((ref) {
//   return null;
// });

final selectedMealProvider = StateProvider<MealDetail?>((ref) {
  return null;
});


// Proveedor para manejar la lista de comidas
final mealProvider = StateNotifierProvider<MealProvider, List<Meal>>((ref) {
  return MealProvider();
});

class MealProvider extends StateNotifier<List<Meal>> {
  MealProvider() : super([]);

  void setMeals(List<Meal> meals) {
    state = meals;
  }

  void removeMeals() {
    state = [];
  }
  
  void addMeal(Meal meal) {
    state = [...state, meal];
  }
  
  void updateMeal(Meal updatedMeal) {
    state = [
      for (final meal in state)
        if (meal.id == updatedMeal.id) updatedMeal else meal,
    ];
  }
  
}