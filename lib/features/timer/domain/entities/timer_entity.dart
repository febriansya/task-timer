/// Entity representing a timer with its properties
class TimerEntity {
  final int id;
  final String name;
  final int totalSeconds;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isActive;
  final String type; // 'countdown', 'pomodoro', 'stopwatch'

  const TimerEntity({
    required this.id,
    required this.name,
    required this.totalSeconds,
    required this.createdAt,
    this.completedAt,
    this.isActive = false,
    this.type = 'countdown',
  });

  /// Creates a copy of this entity with specified fields replaced by new values
  TimerEntity copyWith({
    int? id,
    String? name,
    int? totalSeconds,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isActive,
    String? type,
  }) {
    return TimerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }

  /// Creates a running timer from this entity
  TimerEntity asRunning() {
    return copyWith(isActive: true);
  }

  /// Creates a completed timer from this entity
  TimerEntity asCompleted() {
    return copyWith(
      isActive: false,
      completedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'TimerEntity(id: $id, name: $name, totalSeconds: $totalSeconds, createdAt: $createdAt, completedAt: $completedAt, isActive: $isActive, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerEntity &&
        other.id == id &&
        other.name == name &&
        other.totalSeconds == totalSeconds &&
        other.createdAt == createdAt &&
        other.completedAt == completedAt &&
        other.isActive == isActive &&
        other.type == type;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      totalSeconds,
      createdAt,
      completedAt,
      isActive,
      type,
    );
  }
}