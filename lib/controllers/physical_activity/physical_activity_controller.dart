import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/models/physical_activity.dart';

import '../../providers/physical_activity_provider.dart';
import '../../services/physical_activity/physical_activity_service.dart';

class PhysicalActivityController {
  BuildContext? context;

  final PhysicalActivityService _apiService = PhysicalActivityService();
  late Function refresh;
  late WidgetRef ref;

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;
    _apiService.init(context);
    await getAllPhysicalActivities();
  }

  Future<void> getAllPhysicalActivities() async {
    try {
      final List<PhysicalActivity> activities =
          await _apiService.getAllPhysicalActivities();
          ref.read(physicalActivityProvider.notifier).setPhysicalActivities(activities);
    } catch (e) {
      print(e);
    }
  }
}
