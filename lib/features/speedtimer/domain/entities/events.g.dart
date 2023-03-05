// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 2;

  @override
  Event read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Event.cube222;
      case 1:
        return Event.cube333;
      case 2:
        return Event.pyraminx;
      case 3:
        return Event.skewb;
      case 4:
        return Event.clock;
      default:
        return Event.cube222;
    }
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    switch (obj) {
      case Event.cube222:
        writer.writeByte(0);
        break;
      case Event.cube333:
        writer.writeByte(1);
        break;
      case Event.pyraminx:
        writer.writeByte(2);
        break;
      case Event.skewb:
        writer.writeByte(3);
        break;
      case Event.clock:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
