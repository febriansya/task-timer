import 'dart:convert';
import '../../domain/entities/timer_entity.dart';

/// Data model for timer that can be converted to/from JSON
class TimerModel extends TimerEntity {
  const TimerModel({
    required int id,
    required String name,
    required int totalSeconds,
    required DateTime createdAt,
    DateTime? completedAt,
    bool isActive = false,
    String type = 'countdown',
  }) : super(
          id: id,
          name: name,
          totalSeconds: totalSeconds,
          createdAt: createdAt,
          completedAt: completedAt,
          isActive: isActive,
          type: type,
        );

  /// Creates a TimerModel from a TimerEntity
  factory TimerModel.fromEntity(TimerEntity entity) {
    return TimerModel(
      id: entity.id,
      name: entity.name,
      totalSeconds: entity.totalSeconds,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      isActive: entity.isActive,
      type: entity.type,
    );
  }

  /// Creates a TimerEntity from this model
  TimerEntity toEntity() {
    return TimerEntity(
      id: id,
      name: name,
      totalSeconds: totalSeconds,
      createdAt: createdAt,
      completedAt: completedAt,
      isActive: isActive,
      type: type,
    );
  }

  /// Creates a TimerModel from JSON
  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      totalSeconds: json['totalSeconds'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      completedAt: json['completedAt'] != null 
          ? DateTime.tryParse(json['completedAt']) 
          : null,
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? 'countdown',
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalSeconds': totalSeconds,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isActive': isActive,
      'type': type,
    };
  }

  /// Creates a TimerModel from a JSON string
  factory TimerModel.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return TimerModel.fromJson(json);
  }

  /// Converts this model to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Creates a copy of this model with specified fields replaced by new values
  TimerModel copyWith({
    int? id,
    String? name,
    int? totalSeconds,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isActive,
    String? type,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }
}