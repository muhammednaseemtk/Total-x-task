class UserModel {
  final String id;
  final String name;
  final String phone;
  final int age;
  final String? imageUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imageUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      age: json['age'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] is String
          ? DateTime.parse(json['createdAt'] as String)
          : json['createdAt'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'age': age,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserModel user) {
    return UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      age: user.age,
      imageUrl: user.imageUrl,
      createdAt: user.createdAt,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    int? age,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
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
  bool get ageAbove25 => age > 25;
  bool get ageBelow25 => age <= 25;
}