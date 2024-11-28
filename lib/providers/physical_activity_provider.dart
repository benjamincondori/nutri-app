import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/physical_activity.dart';

final physicalActivityProvider = StateNotifierProvider<PhysicalActivityProvider, List<PhysicalActivity>>((ref) {
  return PhysicalActivityProvider();
});

class PhysicalActivityProvider extends StateNotifier<List<PhysicalActivity>> {
  PhysicalActivityProvider() : super([]);

  void setPhysicalActivities(List<PhysicalActivity> physicalActivities) {
    state = physicalActivities;
  }

  void removePhysicalActivities() {
    state = [];
  }
}
