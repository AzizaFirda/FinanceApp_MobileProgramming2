import 'package:hive/hive.dart';
part 'budget_model.g.dart';

@HiveType(typeId: 7)
class BudgetModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String categoryId;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String period; // monthly, weekly, yearly

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime updatedAt;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    this.period = 'monthly',
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.create({
    required String categoryId,
    required double amount,
    String period = 'monthly',
  }) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return BudgetModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: categoryId,
      amount: amount,
      period: period,
      startDate: startDate,
      endDate: endDate,
      createdAt: now,
      updatedAt: now,
    );
  }

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    double? amount,
    String? period,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'amount': amount,
      'period': period,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'],
      categoryId: json['categoryId'],
      amount: json['amount'],
      period: json['period'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
