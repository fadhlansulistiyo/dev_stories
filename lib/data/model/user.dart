import 'dart:convert';

class User {
  String? name;
  String? email;
  String? password;

  User({
    this.name,
    this.email,
    this.password,
  });

  @override
  String toString() => 'User(name: $name, email: $email, password: $password)';

  /*
  * objek User mampu mengembalikan data Map ataupun JSON
  * */
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  /*
  * objek User mampu dibandingkan dengan objek User lainnya
  * */
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(name, email, password);
}
