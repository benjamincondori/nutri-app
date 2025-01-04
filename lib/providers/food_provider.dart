import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/food.dart';

// Proveedor para manejar un único alimento
final selectedFoodProvider = StateProvider<Food?>((ref) {
  return null;
});


// Proveedor para manejar la lista de alimentos
final foodProvider = StateNotifierProvider<FoodProvider, List<Food>>((ref) {
  return FoodProvider();
});

class FoodProvider extends StateNotifier<List<Food>> {
  FoodProvider() : super([]);

  void setFoods(List<Food> foods) {
    state = foods;
  }

  void removeFoods() {
    state = [];
  }
  
  void addFood(Food food) {
    state = [...state, food];
  }
  
  void updateFood(Food updatedFood) {
    state = [
      for (final food in state)
        if (food.id == updatedFood.id) updatedFood else food,
    ];
  }
  
}