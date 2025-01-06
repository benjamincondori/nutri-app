import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/services/plan/plan_service.dart';

import '../../models/current_plan.dart';
import '../../models/meal.dart';
import '../../models/meal_detail.dart';
import '../../providers/meal_provider.dart';
import '../../providers/plan_provider.dart';
import '../../services/meal/meal_service.dart';
import '../../shared/utils/my_toastbar.dart';
import '../../shared/utils/shared_pref.dart';
import '../plan/plan_controller.dart';

class MealController {
  BuildContext? context;

  final MealService _apiService = MealService();
  final PlanService _apiPlanService = PlanService();
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
    await getCurrentPlan();
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

  Future<void> toggleMealStatus(int mealId, {DateTime? date}) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final String message = await _apiService.markAsConsumed(mealId, token);
        MyToastBar.showSuccess(context!, message);

        // Obtener el id del plan seleccionado
        final CurrentPlan? currentPlan = ref.read(selectedPlanProvider);

        if (currentPlan != null) {
          print(
              "MealController::markAsConsumed::currentPlan: ${currentPlan.toJson()}");
          // Actualizar el plan seleccionado
          await getPlanById(currentPlan.planId);
        }
        // Actualizar el estado del plan actual
        await getCurrentPlan(date: date);
        refresh();
      } catch (e) {
        print(e);
        MyToastBar.showError(
            context!, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> getPlanById(int id) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final CurrentPlan plan = await _apiPlanService.getPlanById(id, token);

        // Actualizar el estado del plan seleccionado
        ref.read(selectedPlanProvider.notifier).state = plan;
        print("PlanController::getPlanById::plan: ${plan.toJson()}");
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getCurrentPlan({DateTime? date}) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final CurrentPlan plan = await _apiPlanService.getCurrentPlan(token);
        ref.read(currentPlanProvider.notifier).state = plan;
        
        if (date != null) {
          // Actualizar el estado de la comida seleccionada
          loadDataMeals(date, ref);
        } else {
          // Actualizar el estado de la comida seleccionada
          loadDataMeals(DateTime.now(), ref);
        }

        print("PlanController::getCurrentPlan::plan: ${plan.toJson()}");
      } catch (e) {
        print(e);
      }
    }
  }

  // void toggleMealStatus(int mealId) async {
  //   await markAsConsumed(mealId);
  // }
}
