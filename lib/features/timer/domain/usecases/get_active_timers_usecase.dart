import '../entities/timer_entity.dart';
import '../repositories/timer_repository.dart';

/// Use case for getting active timers
class GetActiveTimersUseCase {
  final TimerRepository _repository;

  GetActiveTimersUseCase(this._repository);

  /// Gets all active timers
  Future<List<TimerEntity>> execute() async {
    final allTimers = await _repository.getTimers();
    return allTimers.where((timer) => timer.isActive).toList();
  }
}