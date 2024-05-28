class Admin {
  String name;
  String email;
  String password;
  String dateEnter;

  Admin({
    required this.name,
    required this.email,
    required this.password,
    required this.dateEnter,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      dateEnter: json['dateEnter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'dateEnter': dateEnter,
    };
  }
}
