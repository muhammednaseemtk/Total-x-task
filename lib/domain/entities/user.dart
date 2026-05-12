class User {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String? imageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imageUrl,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? phone,
    int? age,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isOlder => age >= 60;
  bool get isYounger => age < 60;
}