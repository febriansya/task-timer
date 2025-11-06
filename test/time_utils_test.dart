import 'package:flutter_test/flutter_test.dart';
import 'package:your_timer/features/timer/domain/entities/timer_entity.dart';
import 'package:your_timer/core/utils/time_utils.dart';

void main() {
  group('TimeUtils Tests', () {
    test('formatTime should correctly format seconds to HH:MM:SS', () {
      // Test various time values
      expect(TimeUtils.formatTime(0), '00:00:00');
      expect(TimeUtils.formatTime(1), '00:00:01');
      expect(TimeUtils.formatTime(60), '00:01:00');
      expect(TimeUtils.formatTime(3600), '01:00:00');
      expect(TimeUtils.formatTime(3661), '01:01:01');
      expect(TimeUtils.formatTime(7200), '02:00:00');
    });

    test('calculateTotalSeconds should calculate correctly', () {
      expect(TimeUtils.calculateTotalSeconds(1, 0, 0), 3600);
      expect(TimeUtils.calculateTotalSeconds(0, 1, 0), 60);
      expect(TimeUtils.calculateTotalSeconds(0, 0, 1), 1);
      expect(TimeUtils.calculateTotalSeconds(1, 1, 1), 3661);
    });

    test('isValidTime should validate time values correctly', () {
      // Valid times
      expect(TimeUtils.isValidTime(0, 0, 1), true);
      expect(TimeUtils.isValidTime(1, 0, 0), true);
      expect(TimeUtils.isValidTime(23, 59, 59), true);
      expect(TimeUtils.isValidTime(12, 30, 45), true);

      // Invalid times
      expect(TimeUtils.isValidTime(0, 0, 0), false); // All zero
      expect(TimeUtils.isValidTime(24, 0, 0), false); // Hours > 23
      expect(TimeUtils.isValidTime(0, 60, 0), false); // Minutes > 59
      expect(TimeUtils.isValidTime(0, 0, 60), false); // Seconds > 59
      expect(TimeUtils.isValidTime(-1, 0, 0), false); // Negative values
    });
  });

  group('TimerEntity Tests', () {
    test('TimerEntity should be created with correct properties', () {
      final timer = TimerEntity(
        id: 1,
        name: 'Test Timer',
        totalSeconds: 60,
        createdAt: DateTime(2023, 1, 1),
        type: 'countdown',
      );

      expect(timer.id, 1);
      expect(timer.name, 'Test Timer');
      expect(timer.totalSeconds, 60);
      expect(timer.createdAt, DateTime(2023, 1, 1));
      expect(timer.type, 'countdown');
      expect(timer.isActive, false);
      expect(timer.completedAt, null);
    });

    test('TimerEntity copyWith should create updated entity', () {
      final originalTimer = TimerEntity(
        id: 1,
        name: 'Original Timer',
        totalSeconds: 60,
        createdAt: DateTime(2023, 1, 1),
        type: 'countdown',
      );

      final updatedTimer = originalTimer.copyWith(
        name: 'Updated Timer',
        totalSeconds: 120,
        isActive: true,
      );

      expect(updatedTimer.name, 'Updated Timer');
      expect(updatedTimer.totalSeconds, 120);
      expect(updatedTimer.isActive, true);
      // Original properties should remain unchanged
      expect(updatedTimer.id, 1);
      expect(updatedTimer.createdAt, DateTime(2023, 1, 1));
      expect(updatedTimer.type, 'countdown');
    });
  });
}