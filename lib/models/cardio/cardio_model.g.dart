// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardio_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardioModelAdapter extends TypeAdapter<CardioModel> {
  @override
  final int typeId = 1;

  @override
  CardioModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardioModel(
      id: fields[0] as int?,
      cardioName: fields[1] as String,
      durationMillis: fields[2] as int,
      caloriesBurnt: fields[3] as double,
      cardioDate: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CardioModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardioName)
      ..writeByte(2)
      ..write(obj.durationMillis)
      ..writeByte(3)
      ..write(obj.caloriesBurnt)
      ..writeByte(4)
      ..write(obj.cardioDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardioModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
