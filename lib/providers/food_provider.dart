import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/food.dart';

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
  
}