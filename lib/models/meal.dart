class Meal {
  final int? id;
  final String mealType;
  final String name;
  final bool status;
  final double totalCalories;
  final double totalCarbohydrates;
  final double totalFats;
  final double totalProteins;

  Meal({
    this.id,
    required this.mealType,
    required this.name,
    required this.status,
    required this.totalCalories,
    required this.totalCarbohydrates,
    required this.totalFats,
    required this.totalProteins,
  });

  Meal copyWith({
    int? id,
    String? mealType,
    String? name,
    bool? status,
    double? totalCarbohydrates,
    double? totalCalories,
    double? totalFats,
    double? totalProteins,
  }) =>
      Meal(
        id: id ?? this.id,
        mealType: mealType ?? this.mealType,
        name: name ?? this.name,
        status: status ?? this.status,
        totalCalories: totalCalories ?? this.totalCalories,
        totalCarbohydrates: totalCarbohydrates ?? this.totalCarbohydrates,
        totalFats: totalFats ?? this.totalFats,
        totalProteins: totalProteins ?? this.totalProteins,
      );

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json["id"],
        mealType: json["meal_type"],
        name: json["name"],
        status: json["status"],
        totalCalories: json["total_calories"],
        totalCarbohydrates: json["total_carbohydrates"],
        totalFats: json["total_fats"]?.toDouble(),
        totalProteins: json["total_proteins"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "meal_type": mealType,
        "name": name,
        "status": status,
        "total_calories": totalCalories,
        "total_carbohydrates": totalCarbohydrates,
        "total_fats": totalFats,
        "total_proteins": totalProteins,
      };
}
