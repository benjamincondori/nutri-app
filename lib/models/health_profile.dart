class HealthProfile {
  final int age;
  final String healthRestrictions;
  final double height;
  final int physicalActivityId;
  final double weight;
  final int userId;
  final DateTime birthday;
  final String gender;

  HealthProfile({
    required this.age,
    required this.healthRestrictions,
    required this.height,
    required this.physicalActivityId,
    required this.weight,
    required this.userId,
    required this.birthday,
    required this.gender,
  });

  HealthProfile copyWith({
    int? age,
    String? healthRestrictions,
    double? height,
    int? physicalActivityId,
    double? weight,
    int? userId,
    DateTime? birthday,
    String? gender,
  }) =>
      HealthProfile(
        age: age ?? this.age,
        healthRestrictions: healthRestrictions ?? this.healthRestrictions,
        height: height ?? this.height,
        physicalActivityId: physicalActivityId ?? this.physicalActivityId,
        weight: weight ?? this.weight,
        userId: userId ?? this.userId,
        birthday: birthday ?? this.birthday,
        gender: gender ?? this.gender,
      );

  factory HealthProfile.fromJson(Map<String, dynamic> json) => HealthProfile(
        age: json["age"],
        healthRestrictions: json["health_restrictions"],
        height: json["height"],
        physicalActivityId: json["physical_activity_id"],
        weight: json["weight"]?.toDouble(),
        userId: json["user_id"],
        birthday: DateTime.parse(json["birthday"]),
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "health_restrictions": healthRestrictions,
        "height": height,
        "physical_activity_id": physicalActivityId,
        "weight": weight,
        "user_id": userId,
        "birthday":
            "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "gender": gender,
      };
}
