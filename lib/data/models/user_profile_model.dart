import 'package:hive/hive.dart';
part 'user_profile_model.g.dart';

@HiveType(typeId: 6)
class UserProfileModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? photoPath;

  @HiveField(3)
  String currency; // USD, EUR, IDR, etc.

  @HiveField(4)
  String language; // en, id, etc.

  @HiveField(5)
  String dateFormat; // dd/MM/yyyy, MM/dd/yyyy, yyyy-MM-dd

  @HiveField(6)
  String themeMode; // light, dark, system

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  @HiveField(9)
  String? photoUrl;

  UserProfileModel({
    required this.name,
    this.email,
    this.photoPath,
    this.photoUrl,
    this.currency = 'IDR',
    this.language = 'id',
    this.dateFormat = 'dd/MM/yyyy',
    this.themeMode = 'system',
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.create({
    String name = 'User',
    String? email,
    String? photoPath,
    String? photoUrl,
    String currency = 'IDR',
    String language = 'id',
    String dateFormat = 'dd/MM/yyyy',
    String themeMode = 'system',
  }) {
    final now = DateTime.now();
    return UserProfileModel(
      name: name,
      email: email,
      photoPath: photoPath,
      photoUrl: photoUrl,
      currency: currency,
      language: language,
      dateFormat: dateFormat,
      themeMode: themeMode,
      createdAt: now,
      updatedAt: now,
    );
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? photoPath,
    String? photoUrl,
    String? currency,
    String? language,
    String? dateFormat,
    String? themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      photoPath: photoPath ?? this.photoPath,
      photoUrl: photoUrl ?? this.photoUrl,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      dateFormat: dateFormat ?? this.dateFormat,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoPath': photoPath,
      'photoUrl': photoUrl,
      'currency': currency,
      'language': language,
      'dateFormat': dateFormat,
      'themeMode': themeMode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? 'User',
      email: json['email'],
      photoPath: json['photoPath'],
      photoUrl: json['photoUrl'],
      currency: json['currency'] ?? 'IDR',
      language: json['language'] ?? 'id',
      dateFormat: json['dateFormat'] ?? 'dd/MM/yyyy',
      themeMode: json['themeMode'] ?? 'system',
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.parse(
              json['createdAt'] ?? DateTime.now().toIso8601String(),
            ),
      updatedAt: json['updatedAt'] is DateTime
          ? json['updatedAt']
          : DateTime.parse(
              json['updatedAt'] ?? DateTime.now().toIso8601String(),
            ),
    );
  }
}
