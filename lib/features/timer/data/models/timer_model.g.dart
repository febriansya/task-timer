// This is a placeholder file. In a real implementation, you would use build_runner
// to generate this file from timer_model.dart using hive_generator.
// For now, we'll create a manual adapter.

import 'package:hive/hive.dart';
import 'timer_model.dart';

class TimerModelAdapter extends TypeAdapter<TimerModel> {
  @override
  final int typeId = 0;

  @override
  TimerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      final index = reader.readByte();
      final value = reader.read();
      fields[index] = value;
    }
    return TimerModel(
      id: fields[0] as int,
      name: fields[1] as String,
      totalSeconds: fields[2] as int,
      createdAt: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
      isActive: fields[5] as bool,
      type: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalSeconds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}