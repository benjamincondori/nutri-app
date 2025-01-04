class Food {
  final String benefits;
  final double calories;
  final double carbohydrates;
  final String category;
  final String description;
  final double fats;
  final int? id;
  final String? imageUrl;
  final String name;
  final double proteins;

  final double? quantity;
  final String? typeQuantity;

  Food({
    required this.benefits,
    required this.calories,
    required this.carbohydrates,
    required this.category,
    required this.description,
    required this.fats,
    this.id,
    this.imageUrl,
    required this.name,
    required this.proteins,
    this.quantity,
    this.typeQuantity,
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
    double? quantity,
    String? typeQuantity,
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
        quantity: quantity ?? this.quantity,
        typeQuantity: typeQuantity ?? this.typeQuantity,
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
        quantity: json["quantity"]?.toDouble(),
        typeQuantity: json["type_quantity"],
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
        "quantity": quantity,
        "type_quantity": typeQuantity,
      };

  @override
  String toString() {
    return '{id: $id, name: $name, category: $category, description: $description, benefits: $benefits, calories: $calories, carbohydrates: $carbohydrates, fats: $fats, proteins: $proteins, imageUrl: $imageUrl}, quantity: $quantity, typeQuantity: $typeQuantity';
  }
}
