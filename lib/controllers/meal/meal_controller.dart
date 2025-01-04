import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/meal.dart';
import '../../models/meal_detail.dart';
import '../../providers/meal_provider.dart';
import '../../services/meal/meal_service.dart';
import '../../shared/utils/my_toastbar.dart';

class MealController {
  BuildContext? context;

  final MealService _apiService = MealService();
  late Function refresh;
  late WidgetRef ref;

  String? selectedCategory;

  // Controladores para cada campo
  final TextEditingController nameController = TextEditingController();

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;

    _apiService.init(context);

    await getAllMeals();
  }

  Future<void> getAllMeals() async {
    try {
      final List<Meal> meals = await _apiService.getAllMeals();
      ref.read(mealProvider.notifier).setMeals(meals);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMeal() async {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      MyToastBar.showInfo(context!, 'Todos los campos son requeridos');
      return;
    }

    if (selectedCategory == null) {
      MyToastBar.showInfo(context!, 'Selecciona el tipo de comida');
      return;
    }

    Meal meal = Meal(
      name: name,
      totalCalories: 0,
      totalCarbohydrates: 0,
      totalFats: 0,
      totalProteins: 0,
      status: false,
      mealType: selectedCategory!,
    );

    try {
      final Meal newMeal = await _apiService.addMeal(meal);
      // Agregar la nueva comida a la lista
      ref.read(mealProvider.notifier).addMeal(newMeal);
      refresh();

      MyToastBar.showSuccess(context!, 'Comida agregada correctamente');
      context!.pop();
    } catch (e) {
      print("Error al agregar la comida: $e");
      MyToastBar.showError(context!, 'Ocurrió un error al agregar la comida');
    }
  }

  Future<void> updateMeal(Meal currentMeal) async {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      MyToastBar.showInfo(context!, 'Todos los campos son requeridos');
      return;
    }

    if (selectedCategory == null) {
      MyToastBar.showInfo(context!, 'Selecciona el tipo de comida');
      return;
    }

    Meal meal = Meal(
      id: currentMeal.id,
      name: name,
      totalCalories: currentMeal.totalCalories,
      totalCarbohydrates: currentMeal.totalCarbohydrates,
      totalFats: currentMeal.totalFats,
      totalProteins: currentMeal.totalProteins,
      status: currentMeal.status,
      mealType: selectedCategory!,
    );

    try {
      final Meal updatedMeal = await _apiService.updateMeal(meal);
      // Actualizar la comida en la lista
      ref.read(mealProvider.notifier).updateMeal(updatedMeal);

      // Actualizar la comida seleccionada
      final currentMealDetail = ref.read(selectedMealProvider);
      ref.read(selectedMealProvider.notifier).state =
          currentMealDetail!.copyWith(meal: updatedMeal);

      refresh();

      MyToastBar.showSuccess(context!, 'Comida actualizada correctamente');
      context!.pop();
    } catch (e) {
      print("Error al actualizar la comida: $e");
      MyToastBar.showError(
          context!, 'Ocurrió un error al actualizar la comida');
    }
  }

  Future<void> getFoodsByMeal(int mealId) async {
    try {
      final MealDetail mealDetail = await _apiService.getFoodsByMeal(mealId);

      // Actualizar el estado de la comida seleccionada
      ref.read(selectedMealProvider.notifier).state = mealDetail;
      refresh();
    } catch (e) {
      print(e);
    }
  }
}
