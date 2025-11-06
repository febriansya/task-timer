import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Service to handle Hive initialization and setup
class HiveService {
  static Future<void> init() async {
    // Initialize Hive with Flutter
    await Hive.initFlutter();
    
    // Open boxes - we'll use dynamic type for now without custom adapters
    await Hive.openBox(AppConstants.timerHistoryBox);
    await Hive.openBox(AppConstants.preferencesBox);
  }
  
  static Future<void> close() async {
    await Hive.close();
  }
}