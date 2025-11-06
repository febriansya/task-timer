/// Utility class for time-related operations
class TimeUtils {
  /// Formats seconds into HH:MM:SS format
  static String formatTime(int totalSeconds) {
    int hours = (totalSeconds ~/ 3600).toInt();
    int minutes = ((totalSeconds % 3600) ~/ 60).toInt();
    int seconds = (totalSeconds % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Calculates remaining seconds from hours, minutes, seconds
  static int calculateTotalSeconds(int hours, int minutes, int seconds) {
    return hours * 3600 + minutes * 60 + seconds;
  }

  /// Validates if the time values are within acceptable ranges
  static bool isValidTime(int hours, int minutes, int seconds) {
    return hours >= 0 && hours <= 23 &&
           minutes >= 0 && minutes <= 59 &&
           seconds >= 0 && seconds <= 59 &&
           (hours + minutes + seconds) > 0; // At least one should be greater than 0
  }
}