// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultEntityAdapter extends TypeAdapter<ResultEntity> {
  @override
  final int typeId = 2;

  @override
  ResultEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultEntity(
      time: fields[0] as int,
      scramble: fields[1] as String,
      description: fields[2] as String,
      event: fields[3] as Event,
      isDNF: fields[4] as bool,
      isPlus: fields[5] as bool,
      index: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ResultEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.scramble)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.event)
      ..writeByte(4)
      ..write(obj.isDNF)
      ..writeByte(5)
      ..write(obj.isPlus)
      ..writeByte(6)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
