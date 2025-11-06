import '../entities/timer_entity.dart';
import '../repositories/timer_repository.dart';

/// Use case for starting a timer
class StartTimerUseCase {
  final TimerRepository _repository;

  StartTimerUseCase(this._repository);

  /// Starts a timer with the given parameters
  Future<TimerEntity> execute({
    required String name,
    required int totalSeconds,
    String type = 'countdown',
  }) async {
    // Validate the input
    if (totalSeconds <= 0) {
      throw ArgumentError('Total seconds must be greater than 0');
    }
    
    if (name.trim().isEmpty) {
      throw ArgumentError('Timer name cannot be empty');
    }

    // Create and start the timer
    final timer = TimerEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      totalSeconds: totalSeconds,
      createdAt: DateTime.now(),
      type: type,
    );

    return await _repository.startTimer(
      name: name,
      totalSeconds: totalSeconds,
      type: type,
    );
  }
}