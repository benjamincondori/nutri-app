import 'package:intl/intl.dart';

class NutritionDataPoint {
  final DateTime date;
  final double calories;
  final double proteins;
  final double carbohydrates;
  final double fats;

  NutritionDataPoint({
    required this.date,
    required this.calories,
    required this.proteins,
    required this.carbohydrates,
    required this.fats,
  });
}

class NutritionDataProcessor {
  static List<NutritionDataPoint> processData(
    List<Map<String, dynamic>> plans,
    String timeframe,
  ) {
    final now = DateTime.now();
    final startDate = timeframe == 'day'
        ? now.subtract(Duration(days: 6))
        : timeframe == 'week'
            ? now.subtract(Duration(days: 7))
            : now.subtract(Duration(days: 30));

    final Map<String, NutritionDataPoint> aggregatedData = {};

    for (var plan in plans) {
      for (var meal in plan['meals']) {
        final mealDate = DateTime.parse(meal['date']);
        if (mealDate.isAfter(startDate)) {
          final dateKey = DateFormat('yyyy-MM-dd').format(mealDate);
          if (!aggregatedData.containsKey(dateKey)) {
            aggregatedData[dateKey] = NutritionDataPoint(
              date: mealDate,
              calories: 0,
              proteins: 0,
              carbohydrates: 0,
              fats: 0,
            );
          }
          aggregatedData[dateKey] = NutritionDataPoint(
            date: mealDate,
            calories: aggregatedData[dateKey]!.calories + meal['total_calories'],
            proteins: aggregatedData[dateKey]!.proteins + meal['total_proteins'],
            carbohydrates: aggregatedData[dateKey]!.carbohydrates + meal['total_carbohydrates'],
            fats: aggregatedData[dateKey]!.fats + meal['total_fats'],
          );
        }
      }
    }

    return aggregatedData.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

