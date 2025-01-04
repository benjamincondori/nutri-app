import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/meal_detail.dart';
import '../../providers/meal_provider.dart';
import '../../services/meal/meal_food_service.dart';
import '../../services/meal/meal_service.dart';
import '../../shared/utils/my_toastbar.dart';

class MealFoodController {
  BuildContext? context;

  final MealFoodService _apiService = MealFoodService();
  final MealService _apiMealService = MealService();
  late Function refresh;
  late WidgetRef ref;

  int? selectedFood;

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController typeQuantityController = TextEditingController();

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;

    _apiService.init(context);
  }

  // Añadir un alimento a una comida
  Future<void> addFoodToMeal(int mealId) async {
    if (selectedFood == null) {
      MyToastBar.showInfo(context!, 'Selecciona un alimento');
      return;
    }

    double? quantity = double.tryParse(quantityController.text);
    String typeQuantity = typeQuantityController.text;

    try {
      await _apiService.addFoodToMeal(
          mealId, selectedFood!, quantity, typeQuantity);

      await getFoodsByMeal(mealId);
      MyToastBar.showSuccess(context!, 'Alimento agregado correctamente');

      selectedFood = null;
      context!.pop();
      refresh();
    } catch (e) {
      print(e);
      MyToastBar.showError(
          context!, e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // Eliminar un alimento de una comida
  Future<void> removeFoodFromMeal(int mealId, int foodId) async {
    print('mealId: $mealId, foodId: $foodId');

    try {
      await _apiService.removeFoodFromMeal(mealId, foodId);
      await getFoodsByMeal(mealId);
      MyToastBar.showSuccess(context!, 'Alimento quitado correctamente');
      selectedFood = null;
      refresh();
    } catch (e) {
      print(e);
      MyToastBar.showError(
          context!, e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> getFoodsByMeal(int mealId) async {
    try {
      final MealDetail mealDetail =
          await _apiMealService.getFoodsByMeal(mealId);

      // Actualizar el estado de la comida seleccionada
      ref.read(selectedMealProvider.notifier).state = mealDetail;
      refresh();
    } catch (e) {
      print(e);
    }
  }
}
