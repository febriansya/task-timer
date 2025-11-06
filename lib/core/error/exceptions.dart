/// Exception classes for different error scenarios in the app
abstract class TimerException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  
  TimerException(this.message, [this.stackTrace]);
}

/// Thrown when timer validation fails
class InvalidTimerException extends TimerException {
  InvalidTimerException(String message, [StackTrace? stackTrace]) 
      : super(message, stackTrace);
}

/// Thrown when storage operations fail
class StorageException extends TimerException {
  StorageException(String message, [StackTrace? stackTrace]) 
      : super(message, stackTrace);
}

/// Thrown when timer operations fail
class TimerOperationException extends TimerException {
  TimerOperationException(String message, [StackTrace? stackTrace]) 
      : super(message, stackTrace);
}