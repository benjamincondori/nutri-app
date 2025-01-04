class Plan {
    final double calories;
    final DateTime dateGeneration;
    final String name;
    final int planId;
    final String status;

    Plan({
        required this.calories,
        required this.dateGeneration,
        required this.name,
        required this.planId,
        required this.status,
    });

    Plan copyWith({
        double? calories,
        DateTime? dateGeneration,
        String? name,
        int? planId,
        String? status,
    }) => 
        Plan(
            calories: calories ?? this.calories,
            dateGeneration: dateGeneration ?? this.dateGeneration,
            name: name ?? this.name,
            planId: planId ?? this.planId,
            status: status ?? this.status,
        );

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        calories: json["calories"]?.toDouble(),
        dateGeneration: DateTime.parse(json["date_generation"]),
        name: json["name"],
        planId: json["plan_id"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "calories": calories,
        "date_generation": dateGeneration.toIso8601String(),
        "name": name,
        "plan_id": planId,
        "status": status,
    };
}
