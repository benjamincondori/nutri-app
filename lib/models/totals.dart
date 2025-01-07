class Totals {
    final int totalFoods;
    final int totalMeals;
    final int totalPlans;
    final int totalUsers;

    Totals({
        required this.totalFoods,
        required this.totalMeals,
        required this.totalPlans,
        required this.totalUsers,
    });

    Totals copyWith({
        int? totalFoods,
        int? totalMeals,
        int? totalPlans,
        int? totalUsers,
    }) => 
        Totals(
            totalFoods: totalFoods ?? this.totalFoods,
            totalMeals: totalMeals ?? this.totalMeals,
            totalPlans: totalPlans ?? this.totalPlans,
            totalUsers: totalUsers ?? this.totalUsers,
        );

    factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        totalFoods: json["total_foods"],
        totalMeals: json["total_meals"],
        totalPlans: json["total_plans"],
        totalUsers: json["total_users"],
    );

    Map<String, dynamic> toJson() => {
        "total_foods": totalFoods,
        "total_meals": totalMeals,
        "total_plans": totalPlans,
        "total_users": totalUsers,
    };
}
