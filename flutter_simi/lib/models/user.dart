class User {
  int? id;
  var email;
  var roles;
  var password;


  User({
    this.id,
    required this.email,
    required this.roles,
    required this.password,
  });

  factory User.fromJson(Map json) {
    return User(
        id: json['id'],
        email: json['email'],
        roles: json['roles'],
        password: json['password'],
      );
  }

  Map toJson() {
    return {
      'id': id,
      'email': email,
      'roles': roles,
      'password': password,
    };
  }
}