import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../models/current_plan.dart';
import '../../models/plan.dart';
import '../../services/plan/plan_service.dart';
import '../../shared/utils/shared_pref.dart';

class PlanController {
  BuildContext? context;

  final PlanService _apiService = PlanService();
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
        print("PlanController::getPlans::plans: $plans");
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getCurrentPlan() async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final CurrentPlan plan = await _apiService.getCurrentPlan(token);
        print("PlanController::getCurrentPlan::plan: $plan");
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getPlanById(int id) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final CurrentPlan plan = await _apiService.getPlanById(id, token);
        print("PlanController::getPlanById::plan: $plan");
      } catch (e) {
        print(e);
      }
    }
  }
}
