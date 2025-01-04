// ignore_for_file: constant_identifier_names

class CurrentPlan {
    final double calories;
    final DateTime dateGeneration;
    final List<Meals> meals;
    final String name;
    final int planId;
    final String status;

    CurrentPlan({
        required this.calories,
        required this.dateGeneration,
        required this.meals,
        required this.name,
        required this.planId,
        required this.status,
    });

    CurrentPlan copyWith({
        double? calories,
        DateTime? dateGeneration,
        List<Meals>? meals,
        String? name,
        int? planId,
        String? status,
    }) => 
        CurrentPlan(
            calories: calories ?? this.calories,
            dateGeneration: dateGeneration ?? this.dateGeneration,
            meals: meals ?? this.meals,
            name: name ?? this.name,
            planId: planId ?? this.planId,
            status: status ?? this.status,
        );

    factory CurrentPlan.fromJson(Map<String, dynamic> json) => CurrentPlan(
        calories: json["calories"]?.toDouble(),
        dateGeneration: DateTime.parse(json["date_generation"]),
        meals: List<Meals>.from(json["meals"].map((x) => Meals.fromJson(x))),
        name: json["name"],
        planId: json["plan_id"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "calories": calories,
        "date_generation": dateGeneration.toIso8601String(),
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
        "name": name,
        "plan_id": planId,
        "status": status,
    };
}

class Meals {
    final DateTime date;
    final int day;
    final List<Foods> foods;
    final int mealId;
    final String mealType;
    final String name;
    final double totalCalories;
    final double totalCarbohydrates;
    final double totalFats;
    final double totalProteins;

    Meals({
        required this.date,
        required this.day,
        required this.foods,
        required this.mealId,
        required this.mealType,
        required this.name,
        required this.totalCalories,
        required this.totalCarbohydrates,
        required this.totalFats,
        required this.totalProteins,
    });

    Meals copyWith({
        DateTime? date,
        int? day,
        List<Foods>? foods,
        int? mealId,
        String? mealType,
        String? name,
        double? totalCalories,
        double? totalCarbohydrates,
        double? totalFats,
        double? totalProteins,
    }) => 
        Meals(
            date: date ?? this.date,
            day: day ?? this.day,
            foods: foods ?? this.foods,
            mealId: mealId ?? this.mealId,
            mealType: mealType ?? this.mealType,
            name: name ?? this.name,
            totalCalories: totalCalories ?? this.totalCalories,
            totalCarbohydrates: totalCarbohydrates ?? this.totalCarbohydrates,
            totalFats: totalFats ?? this.totalFats,
            totalProteins: totalProteins ?? this.totalProteins,
        );

    factory Meals.fromJson(Map<String, dynamic> json) => Meals(
        date: DateTime.parse(json["date"]),
        day: json["day"],
        foods: List<Foods>.from(json["foods"].map((x) => Foods.fromJson(x))),
        mealId: json["meal_id"],
        mealType: json["meal_type"],
        name: json["name"],
        totalCalories: json["total_calories"]?.toDouble(),
        totalCarbohydrates: json["total_carbohydrates"]?.toDouble(),
        totalFats: json["total_fats"]?.toDouble(),
        totalProteins: json["total_proteins"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "day": day,
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "meal_id": mealId,
        "meal_type": mealType,
        "name": name,
        "total_calories": totalCalories,
        "total_carbohydrates": totalCarbohydrates,
        "total_fats": totalFats,
        "total_proteins": totalProteins,
    };
}

class Foods {
    final String benefits;
    final int calories;
    final double carbohydrates;
    final String category;
    final String description;
    final double fats;
    final int foodId;
    final String imageUrl;
    final String name;
    final double proteins;
    final double quantity;
    final TypeQuantity typeQuantity;

    Foods({
        required this.benefits,
        required this.calories,
        required this.carbohydrates,
        required this.category,
        required this.description,
        required this.fats,
        required this.foodId,
        required this.imageUrl,
        required this.name,
        required this.proteins,
        required this.quantity,
        required this.typeQuantity,
    });

    Foods copyWith({
        String? benefits,
        int? calories,
        double? carbohydrates,
        String? category,
        String? description,
        double? fats,
        int? foodId,
        String? imageUrl,
        String? name,
        double? proteins,
        double? quantity,
        TypeQuantity? typeQuantity,
    }) => 
        Foods(
            benefits: benefits ?? this.benefits,
            calories: calories ?? this.calories,
            carbohydrates: carbohydrates ?? this.carbohydrates,
            category: category ?? this.category,
            description: description ?? this.description,
            fats: fats ?? this.fats,
            foodId: foodId ?? this.foodId,
            imageUrl: imageUrl ?? this.imageUrl,
            name: name ?? this.name,
            proteins: proteins ?? this.proteins,
            quantity: quantity ?? this.quantity,
            typeQuantity: typeQuantity ?? this.typeQuantity,
        );

    factory Foods.fromJson(Map<String, dynamic> json) => Foods(
        benefits: json["benefits"],
        calories: json["calories"],
        carbohydrates: json["carbohydrates"]?.toDouble(),
        category: json["category"],
        description: json["description"],
        fats: json["fats"]?.toDouble(),
        foodId: json["food_id"],
        imageUrl: json["image_url"],
        name: json["name"],
        proteins: json["proteins"]?.toDouble(),
        quantity: json["quantity"]?.toDouble(),
        typeQuantity: typeQuantityValues.map[json["type_quantity"]]!,
    );

    Map<String, dynamic> toJson() => {
        "benefits": benefits,
        "calories": calories,
        "carbohydrates": carbohydrates,
        "category": category,
        "description": description,
        "fats": fats,
        "food_id": foodId,
        "image_url": imageUrl,
        "name": name,
        "proteins": proteins,
        "quantity": quantity,
        "type_quantity": typeQuantityValues.reverse[typeQuantity],
    };
}

enum TypeQuantity {
    GRAMO,
    UNIDAD
}

final typeQuantityValues = EnumValues({
    "gramo": TypeQuantity.GRAMO,
    "unidad": TypeQuantity.UNIDAD
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
