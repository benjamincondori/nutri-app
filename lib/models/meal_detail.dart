import 'package:nutrition_ai_app/models/food.dart';
import 'package:nutrition_ai_app/models/meal.dart';

class MealDetail {
  final List<Food> foods;
  final Meal meal;

  MealDetail({
    required this.foods,
    required this.meal,
  });

  MealDetail copyWith({
    List<Food>? foods,
    Meal? meal,
  }) =>
      MealDetail(
        foods: foods ?? this.foods,
        meal: meal ?? this.meal,
      );

  factory MealDetail.fromJson(Map<String, dynamic> json) => MealDetail(
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        meal: Meal.fromJson(json["meal"]),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "meal": meal.toJson(),
      };
}
