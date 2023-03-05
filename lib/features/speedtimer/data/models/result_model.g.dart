// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultModelAdapter extends TypeAdapter<ResultModel> {
  @override
  final int typeId = 1;

  @override
  ResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultModel(
      timeInMillis: fields[0] as int,
      scramble: fields[1] as String,
      isPlus2: fields[2] as bool,
      isDNF: fields[3] as bool,
      event: fields[4] as Event,
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResultModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.timeInMillis)
      ..writeByte(1)
      ..write(obj.scramble)
      ..writeByte(2)
      ..write(obj.isPlus2)
      ..writeByte(3)
      ..write(obj.isDNF)
      ..writeByte(4)
      ..write(obj.event)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
