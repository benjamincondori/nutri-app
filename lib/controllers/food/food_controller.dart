import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/models/food.dart';
import 'package:nutrition_ai_app/services/food/food_service.dart';

import '../../providers/food_provider.dart';

class FoodController {
  
  BuildContext? context;

  final FoodService _apiService = FoodService();
  late Function refresh;
  late WidgetRef ref;

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;
    _apiService.init(context);
    print("Food Controller: init");
    
    await getAllFoods();
  }
  
  Future<void> getAllFoods() async {
    try {
      final List<Food> foods = await _apiService.getAllFoods();
      ref.read(foodProvider.notifier).setFoods(foods);
    } catch (e) {
      print(e);
    }
  }
  
  
}