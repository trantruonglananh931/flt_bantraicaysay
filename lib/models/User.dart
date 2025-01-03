class User {
  final String? username;
  final String? email;
  final String? password;
  final int? role_id;
  final String? full_name;
  final DateTime? birth_year;
  final String? phone_number;
  final String? address;
  final String? gender;

  User({
    this.username,
    this.email,
    this.password,
    this.role_id,
    this.full_name,
    this.birth_year,
    this.phone_number,
    this.address,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role_id: json['role_id'],
      full_name: json['full_name'],
      birth_year: json['birth_year'],
      phone_number: json['phone_number'],
      address: json['address'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role_id': role_id,
      'full_name': full_name,
      'birth_year': birth_year,
      'phone_number': phone_number,
      'address': address,
      'gender': gender,
    };
  }
}

