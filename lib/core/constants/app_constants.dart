/// App constants that will be used throughout the application
class AppConstants {
  // Timer related constants
  static const int maxHours = 23;
  static const int maxMinutes = 59;
  static const int maxSeconds = 59;
  
  // Theme related constants
  static const String appTitle = 'Timer App';
  
  // Storage related constants
  static const String timerHistoryBox = 'timer_history';
  static const String preferencesBox = 'app_preferences';
  
  // Notification related constants
  static const String timerNotificationChannel = 'timer_channel';
  static const String timerNotificationTitle = 'Timer Finished';
  
  // UI related constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultBorderRadius = 12.0;
}