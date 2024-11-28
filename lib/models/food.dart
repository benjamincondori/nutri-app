class Food {
  late String benefits;
  late double calories;
  late double carbohydrates;
  late String category;
  late String description;
  late double fats;
  late int id;
  late String imageUrl;
  late String name;
  late double proteins;

  Food({
    required this.benefits,
    required this.calories,
    required this.carbohydrates,
    required this.category,
    required this.description,
    required this.fats,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.proteins,
  });

  Food copyWith({
    String? benefits,
    double? calories,
    double? carbohydrates,
    String? category,
    String? description,
    double? fats,
    int? id,
    String? imageUrl,
    String? name,
    double? proteins,
  }) =>
      Food(
        benefits: benefits ?? this.benefits,
        calories: calories ?? this.calories,
        carbohydrates: carbohydrates ?? this.carbohydrates,
        category: category ?? this.category,
        description: description ?? this.description,
        fats: fats ?? this.fats,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        name: name ?? this.name,
        proteins: proteins ?? this.proteins,
      );

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        benefits: json["benefits"],
        calories: json["calories"],
        carbohydrates: json["carbohydrates"]?.toDouble(),
        category: json["category"],
        description: json["description"],
        fats: json["fats"]?.toDouble(),
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        proteins: json["proteins"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "benefits": benefits,
        "calories": calories,
        "carbohydrates": carbohydrates,
        "category": category,
        "description": description,
        "fats": fats,
        "id": id,
        "image_url": imageUrl,
        "name": name,
        "proteins": proteins,
      };
      
  @override
  String toString() {
    return '{id: $id, name: $name, category: $category, description: $description, benefits: $benefits, calories: $calories, carbohydrates: $carbohydrates, fats: $fats, proteins: $proteins, imageUrl: $imageUrl}';
  }
}
