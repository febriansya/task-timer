import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/start_timer_usecase.dart';
import '../../domain/usecases/get_active_timers_usecase.dart';
import '../../data/repositories/timer_repository_impl.dart';
import '../../domain/repositories/timer_repository.dart';

// Repository provider
final timerRepositoryProvider = Provider<TimerRepository>((ref) {
  return TimerRepositoryImpl();
});

// Use case providers
final startTimerUseCaseProvider = Provider<StartTimerUseCase>((ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return StartTimerUseCase(repository);
});

final getActiveTimersUseCaseProvider = Provider<GetActiveTimersUseCase>((ref) {
  final repository = ref.watch(timerRepositoryProvider);
  return GetActiveTimersUseCase(repository);
});

// State providers would go here in a complete implementation