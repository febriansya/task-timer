import 'dart:async';
import 'package:hive/hive.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/repositories/timer_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/app_constants.dart';

/// Implementation of TimerRepository using local storage
class TimerRepositoryImpl implements TimerRepository {
  Box? _timerBox;

  TimerRepositoryImpl();

  Future<Box> get _getTimerBox async {
    if (_timerBox != null && Hive.isBoxOpen(AppConstants.timerHistoryBox)) {
      return _timerBox!;
    }

    try {
      // Wait for box to be available (should be initialized by HiveService in main)
      while (!Hive.isBoxOpen(AppConstants.timerHistoryBox)) {
        await Future.delayed(Duration(milliseconds: 10));
      }
      _timerBox = Hive.box(AppConstants.timerHistoryBox);
      return _timerBox!;
    } catch (e) {
      throw StorageException('Failed to get timer storage: $e');
    }
  }

  @override
  Future<TimerEntity> startTimer({
    required String name,
    required int totalSeconds,
    String type = 'countdown',
  }) async {
    try {
      final timerBox = await _getTimerBox;
      final id = DateTime.now().millisecondsSinceEpoch;
      final timerData = {
        'id': id,
        'name': name,
        'totalSeconds': totalSeconds,
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'type': type,
        'completedAt': null,
      };

      await timerBox.put(id, timerData);
      return _mapToTimerEntity(timerData);
    } catch (e) {
      throw StorageException('Failed to start timer: $e');
    }
  }

  @override
  Future<TimerEntity> updateTimer(TimerEntity timer) async {
    try {
      final timerBox = await _getTimerBox;
      final timerData = {
        'id': timer.id,
        'name': timer.name,
        'totalSeconds': timer.totalSeconds,
        'createdAt': timer.createdAt.toIso8601String(),
        'isActive': timer.isActive,
        'type': timer.type,
        'completedAt': timer.completedAt?.toIso8601String(),
      };
      await timerBox.put(timer.id, timerData);
      return timer;
    } catch (e) {
      throw StorageException('Failed to update timer: $e');
    }
  }

  @override
  Future<List<TimerEntity>> getTimers() async {
    try {
      final timerBox = await _getTimerBox;
      final timerDataList = timerBox.values.toList();
      return timerDataList
          .map((data) => _mapToTimerEntity(data))
          .cast<TimerEntity>()
          .toList();
    } catch (e) {
      throw StorageException('Failed to get timers: $e');
    }
  }

  @override
  Future<TimerEntity?> getTimerById(int id) async {
    try {
      final timerBox = await _getTimerBox;
      final timerData = timerBox.get(id);
      if (timerData == null) return null;
      return _mapToTimerEntity(timerData);
    } catch (e) {
      throw StorageException('Failed to get timer by ID: $e');
    }
  }

  @override
  Future<TimerEntity> completeTimer(int id) async {
    try {
      final timerBox = await _getTimerBox;
      final timerData = timerBox.get(id);
      if (timerData == null) {
        throw TimerOperationException('Timer with ID $id not found');
      }

      timerData['isActive'] = false;
      timerData['completedAt'] = DateTime.now().toIso8601String();

      await timerBox.put(id, timerData);
      return _mapToTimerEntity(timerData);
    } catch (e) {
      throw StorageException('Failed to complete timer: $e');
    }
  }

  @override
  Future<void> deleteTimer(int id) async {
    try {
      final timerBox = await _getTimerBox;
      await timerBox.delete(id);
    } catch (e) {
      throw StorageException('Failed to delete timer: $e');
    }
  }

  @override
  Future<void> clearCompletedTimers() async {
    try {
      final timerBox = await _getTimerBox;
      final completedTimerIds = timerBox.values
          .where((data) => data['isActive'] == false)
          .map((data) => data['id'] as int)
          .toList();

      for (final id in completedTimerIds) {
        await timerBox.delete(id);
      }
    } catch (e) {
      throw StorageException('Failed to clear completed timers: $e');
    }
  }

  TimerEntity _mapToTimerEntity(dynamic timerData) {
    final Map<String, dynamic> data = timerData as Map<String, dynamic>;
    return TimerEntity(
      id: data['id'] as int,
      name: data['name'] as String,
      totalSeconds: data['totalSeconds'] as int,
      createdAt: DateTime.parse(data['createdAt'] as String),
      completedAt: data['completedAt'] != null
          ? DateTime.parse(data['completedAt'] as String)
          : null,
      isActive: data['isActive'] as bool,
      type: data['type'] as String,
    );
  }
}
