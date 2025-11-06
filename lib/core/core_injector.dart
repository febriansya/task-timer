import 'package:get_it/get_it.dart';
import '../features/timer/data/repositories/timer_repository_impl.dart';
import '../features/timer/domain/repositories/timer_repository.dart';
import '../features/timer/domain/usecases/start_timer_usecase.dart';
import '../features/timer/domain/usecases/get_active_timers_usecase.dart';

/// Service locator for the application
final getIt = GetIt.instance;

/// Initialize all dependencies
void setupDependencies() {
  // Repositories
  getIt.registerSingleton<TimerRepository>(TimerRepositoryImpl());

  // Use cases
  getIt.registerFactory(() => StartTimerUseCase(getIt()));
  getIt.registerFactory(() => GetActiveTimersUseCase(getIt()));
}