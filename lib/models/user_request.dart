class UserRequest {
  final String email;
  final String lastname;
  final String name;
  final String password;
  final String telephone;

  UserRequest({
    required this.email,
    required this.lastname,
    required this.name,
    required this.password,
    required this.telephone,
  });

  UserRequest copyWith({
    String? email,
    String? lastname,
    String? name,
    String? password,
    String? telephone,
  }) =>
      UserRequest(
        email: email ?? this.email,
        lastname: lastname ?? this.lastname,
        name: name ?? this.name,
        password: password ?? this.password,
        telephone: telephone ?? this.telephone,
      );

  factory UserRequest.fromJson(Map<String, dynamic> json) => UserRequest(
        email: json["email"],
        lastname: json["lastname"],
        name: json["name"],
        password: json["password"],
        telephone: json["telephone"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "lastname": lastname,
        "name": name,
        "password": password,
        "telephone": telephone,
      };
}
