import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../models/current_plan.dart';
import '../../models/meal_detail.dart';
import '../../models/plan.dart';
import '../../providers/meal_provider.dart';
import '../../providers/plan_provider.dart';
import '../../services/meal/meal_service.dart';
import '../../services/plan/plan_service.dart';
import '../../shared/utils/format_date.dart';
import '../../shared/utils/shared_pref.dart';

class PlanController {
  BuildContext? context;

  final PlanService _apiService = PlanService();
  final MealService _apiFoodService = MealService();
  late Function refresh;
  late WidgetRef ref;

  String selectedGoal = '';
  int selectedDays = 3;
  final TextEditingController customGoalController = TextEditingController();

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;

    _apiService.init(context);

    await getPlans();
    // await getCurrentPlan();
  }

  Future<void> generatePlan() async {
    final token = await SharedPref().read('token');

    if (token != null) {
      String objective = selectedGoal.toLowerCase() == 'otro'
          ? customGoalController.text
          : selectedGoal;
      int days = selectedDays;

      if (objective.isEmpty) {
        MyToastBar.showInfo(context!, 'Selecciona un objetivo');
        return;
      }

      // if (days == 0) {
      //   MyToastBar.showInfo(context!, 'Selecciona el número de días');
      //   return;
      // }

      try {
        final Map<String, dynamic> data = {
          "id": 1,
          "number-days": days,
          "objective": objective,
        };
        final response = await _apiService.generatePlan(data, token);
        print("PlanController::generatePlan::response: $response");
        await getPlans();
        MyToastBar.showSuccess(
            context!, 'Plan de comidas generado correctamente');
        context!.pop();
      } catch (e) {
        print(e);
        MyToastBar.showError(
            context!, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> getPlans() async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final List<Plan> plans = await _apiService.getPlans(token);
        ref.read(planProvider.notifier).setPlans(plans);
        // print("PlanController::getPlans::plans: $plans");
      } catch (e) {
        print(e);
      }
    }
  }

  // Future<void> getCurrentPlan() async {
  //   final token = await SharedPref().read('token');

  //   if (token != null) {
  //     try {
  //       final CurrentPlan plan = await _apiService.getCurrentPlan(token);
  //       ref.read(currentPlanProvider.notifier).state = plan;

  //       // Actualizar el estado de la comida seleccionada
  //       loadDataMeals(DateTime.now(), ref);

  //       print("PlanController::getCurrentPlan::plan: $plan");
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  Future<void> getPlanById(int id) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final CurrentPlan plan = await _apiService.getPlanById(id, token);

        // Actualizar el estado del plan seleccionado
        ref.read(selectedPlanProvider.notifier).state = plan;
        print("PlanController::getPlanById::plan: $plan");
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getFoodsByMeal(int mealId) async {
    try {
      final MealDetail mealDetail =
          await _apiFoodService.getFoodsByMeal(mealId);

      // Actualizar el estado de la comida seleccionada
      ref.read(selectedMealProvider.notifier).state = mealDetail;
      refresh();
    } catch (e) {
      print(e);
    }
  }
}

loadDataMeals(DateTime currentDate, WidgetRef ref) {
  final currentPlan = ref.watch(currentPlanProvider);

  if (currentPlan == null) {
    return;
  }

  // Calculamos el día actual del plan con base en la fecha de inicio
  DateTime startDate =
      DateTime.parse(formatOnlyDate(currentPlan.dateGeneration));
  int daysElapsed = currentDate.difference(startDate).inDays + 1;

  // Extraemos los días únicos
  Set<int> uniqueDays = currentPlan.meals.map((meal) => meal.day).toSet();

  // El número de días únicos es el tamaño de ese conjunto
  final numberOfDays = uniqueDays.length;

  // Obtenemos las comidas para el día seleccionado
  List<Meals> mealsForSelectedDay = [];

  // Obtenemos el plan para el día correspondiente (asegurándonos de que el día no esté fuera del rango)
  if (daysElapsed > 0 && daysElapsed <= numberOfDays) {
    mealsForSelectedDay =
        currentPlan.meals.where((meal) => meal.day == daysElapsed).toList();
  }

  // Actualizamos el estado con las comidas del día seleccionado
  ref.read(currentMealsPlanProvider.notifier).state = mealsForSelectedDay;
}
