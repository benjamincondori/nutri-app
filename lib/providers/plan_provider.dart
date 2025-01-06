import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_plan.dart';
import '../models/plan.dart';

// Proveedor para manejar un único plan
final selectedPlanProvider = StateProvider<CurrentPlan?>((ref) {
  return null;
});

// Proveedor para manejar el plan actual
final currentPlanProvider = StateProvider<CurrentPlan?>((ref) {
  return null;
});

// Proveedor para manejar las comidas del plan actual
final currentMealsPlanProvider = StateProvider<List<Meals>>((ref) {
  return [];
});

// Proveedor para manejar la lista de planes
final planProvider = StateNotifierProvider<PlanProvider, List<Plan>>((ref) {
  return PlanProvider();
});

class PlanProvider extends StateNotifier<List<Plan>> {
  PlanProvider() : super([]);

  void setPlans(List<Plan> plans) {
    state = plans;
  }

  void removePlans() {
    state = [];
  }

  void addPlan(Plan plan) {
    state = [...state, plan];
  }

  void updatePlan(Plan updatedPlan) {
    state = [
      for (final plan in state)
        if (plan.planId == updatedPlan.planId) updatedPlan else plan,
    ];
  }
}
