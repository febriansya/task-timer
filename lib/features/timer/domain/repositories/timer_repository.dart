import '../entities/timer_entity.dart';

/// Repository interface for timer operations
abstract class TimerRepository {
  /// Starts a timer with the given parameters
  Future<TimerEntity> startTimer({
    required String name,
    required int totalSeconds,
    String type = 'countdown',
  });

  /// Updates an existing timer
  Future<TimerEntity> updateTimer(TimerEntity timer);

  /// Gets all timers
  Future<List<TimerEntity>> getTimers();

  /// Gets a specific timer by ID
  Future<TimerEntity?> getTimerById(int id);

  /// Completes a timer
  Future<TimerEntity> completeTimer(int id);

  /// Deletes a timer
  Future<void> deleteTimer(int id);

  /// Clears all completed timers
  Future<void> clearCompletedTimers();
}