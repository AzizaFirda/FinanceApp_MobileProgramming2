import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
  @HiveField(2)
  transfer,
}

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  TransactionType type;

  @HiveField(3)
  String categoryId;

  @HiveField(4)
  String accountId;

  @HiveField(5)
  String? toAccountId; // For transfer

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  String? note;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.accountId,
    this.toAccountId,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  TransactionModel copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? accountId,
    String? toAccountId,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type.toString(),
      'categoryId': categoryId,
      'accountId': accountId,
      'toAccountId': toAccountId,
      'date': date.toIso8601String(),
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'].toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      categoryId: json['categoryId'],
      accountId: json['accountId'],
      toAccountId: json['toAccountId'],
      date: DateTime.parse(json['date']),
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
