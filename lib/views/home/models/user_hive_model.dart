import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String phone;

  @HiveField(3)
  late int age;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  late DateTime createdAt;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    this.imagePath,
    required this.createdAt,
  });
}