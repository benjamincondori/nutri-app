class PhysicalActivity {
  final double pal;
  final String description;
  final int id;
  final String name;

  PhysicalActivity({
    required this.pal,
    required this.description,
    required this.id,
    required this.name,
  });

  PhysicalActivity copyWith({
    double? pal,
    String? description,
    int? id,
    String? name,
  }) =>
      PhysicalActivity(
        pal: pal ?? this.pal,
        description: description ?? this.description,
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) =>
      PhysicalActivity(
        pal: json["PAL"]?.toDouble(),
        description: json["description"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "PAL": pal,
        "description": description,
        "id": id,
        "name": name,
      };
      
  @override
  String toString() {
    return '{id: $id, name: $name, PAL: $pal, description: $description}';
  }
}
