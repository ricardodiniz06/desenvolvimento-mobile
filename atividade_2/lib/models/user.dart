class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone; 
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'] ??
          'Não informado', 
      avatar: json['avatar'],
    );
  }

  User copyWith(
      {String? firstName,
      String? lastName,
      String? email,
      String? phone,
      String? avatar}) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }
}
