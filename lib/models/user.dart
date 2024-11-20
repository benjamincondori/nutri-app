class User {
  final String email;
  final HealthProfile1 healthProfile;
  final int id;
  final String lastname;
  final String name;
  final String telephone;
  final String urlImage;

  User({
    required this.email,
    required this.healthProfile,
    required this.id,
    required this.lastname,
    required this.name,
    required this.telephone,
    required this.urlImage,
  });

  User copyWith({
    String? email,
    HealthProfile1? healthProfile,
    int? id,
    String? lastname,
    String? name,
    String? telephone,
    String? urlImage,
  }) =>
      User(
        email: email ?? this.email,
        healthProfile: healthProfile ?? this.healthProfile,
        id: id ?? this.id,
        lastname: lastname ?? this.lastname,
        name: name ?? this.name,
        telephone: telephone ?? this.telephone,
        urlImage: urlImage ?? this.urlImage,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        healthProfile: HealthProfile1.fromJson(json["health_profile"]),
        id: json["id"],
        lastname: json["lastname"],
        name: json["name"],
        telephone: json["telephone"],
        urlImage: json["url_image"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "health_profile": healthProfile.toJson(),
        "id": id,
        "lastname": lastname,
        "name": name,
        "telephone": telephone,
        "url_image": urlImage,
      };
}

class HealthProfile1 {
  final int age;
  final String healthRestrictions;
  final double height;
  final int id;
  final String physicalActivity;
  final DateTime updateDate;
  final int userId;
  final double weight;

  HealthProfile1({
    required this.age,
    required this.healthRestrictions,
    required this.height,
    required this.id,
    required this.physicalActivity,
    required this.updateDate,
    required this.userId,
    required this.weight,
  });

  HealthProfile1 copyWith({
    int? age,
    String? healthRestrictions,
    double? height,
    int? id,
    String? physicalActivity,
    DateTime? updateDate,
    int? userId,
    double? weight,
  }) =>
      HealthProfile1(
        age: age ?? this.age,
        healthRestrictions: healthRestrictions ?? this.healthRestrictions,
        height: height ?? this.height,
        id: id ?? this.id,
        physicalActivity: physicalActivity ?? this.physicalActivity,
        updateDate: updateDate ?? this.updateDate,
        userId: userId ?? this.userId,
        weight: weight ?? this.weight,
      );

  factory HealthProfile1.fromJson(Map<String, dynamic> json) => HealthProfile1(
        age: json["age"],
        healthRestrictions: json["health_restrictions"],
        height: json["height"],
        id: json["id"],
        physicalActivity: json["physical_activity"],
        updateDate: DateTime.parse(json["update_date"]),
        userId: json["user_id"],
        weight: json["weight"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "health_restrictions": healthRestrictions,
        "height": height,
        "id": id,
        "physical_activity": physicalActivity,
        "update_date": updateDate.toIso8601String(),
        "user_id": userId,
        "weight": weight,
      };
}
