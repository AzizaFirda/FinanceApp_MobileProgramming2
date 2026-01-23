import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  @HiveField(3)
  DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
  });

  factory CategoryModel.create({
    required String name,
    required String icon,
  }) {
    return CategoryModel(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      createdAt: DateTime.now(),
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
