import 'package:hive/hive.dart';
part 'account_model.g.dart';

@HiveType(typeId: 2)
enum AccountType {
  @HiveField(0)
  cash,
  @HiveField(1)
  bank,
  @HiveField(2)
  ewallet,
  @HiveField(3)
  liability, // For debts
}

@HiveType(typeId: 3)
class AccountModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  AccountType type;

  @HiveField(3)
  String icon;

  @HiveField(4)
  int color; // Store as int for Hive

  @HiveField(5)
  double initialBalance;

  @HiveField(6)
  double currentBalance;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.initialBalance,
    required this.currentBalance,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountModel.create({
    required String name,
    required AccountType type,
    required String icon,
    required int color,
    double initialBalance = 0,
  }) {
    final now = DateTime.now();
    return AccountModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      icon: icon,
      color: color,
      initialBalance: initialBalance,
      currentBalance: initialBalance,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  AccountModel copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? icon,
    int? color,
    double? initialBalance,
    double? currentBalance,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void updateBalance(double amount) {
    currentBalance += amount;
    updatedAt = DateTime.now();
  }

  bool get isAsset => type != AccountType.liability;
  bool get isLiability => type == AccountType.liability;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'icon': icon,
      'color': color,
      'initialBalance': initialBalance,
      'currentBalance': currentBalance,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      type: AccountType.values[json['type']],
      icon: json['icon'],
      color: json['color'],
      initialBalance: json['initialBalance'],
      currentBalance: json['currentBalance'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
