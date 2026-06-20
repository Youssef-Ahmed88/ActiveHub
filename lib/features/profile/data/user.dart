class User {
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final List<String> bookings;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.bookings,
  });

  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? photo,
    List<String>? bookings,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      bookings: bookings ?? this.bookings,
    );
  }
}
