// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_guide_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutGuideAdapter extends TypeAdapter<WorkoutGuide> {
  @override
  final int typeId = 0;

  @override
  WorkoutGuide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutGuide(
      id: fields[0] as int?,
      workoutName: fields[1] as String,
      gifpath: fields[2] as String?,
      description: fields[3] as String,
      muscle: fields[4] as String,
      gifLink: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutGuide obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workoutName)
      ..writeByte(2)
      ..write(obj.gifpath)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.muscle)
      ..writeByte(5)
      ..write(obj.gifLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutGuideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
