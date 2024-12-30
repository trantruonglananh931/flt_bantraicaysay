class User {
  final String? username;
  final String? email;
  final String? password;
  final int? roleId;
  final String? fullName;
  final int? birthYear;
  final String? phoneNumber;
  final String? address;
  final String? gender;

  User({
    this.username,
    this.email,
    this.password,
    this.roleId,
    this.fullName,
    this.birthYear,
    this.phoneNumber,
    this.address,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      roleId: json['role_id'],
      fullName: json['full_name'],
      birthYear: json['birth_year'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role_id': roleId,
      'full_name': fullName,
      'birth_year': birthYear,
      'phone_number': phoneNumber,
      'address': address,
      'gender': gender,
    };
  }
}

