// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Event.event2by2;
      case 1:
        return Event.event3by3;
      case 2:
        return Event.eventPyra;
      case 3:
        return Event.eventSkewb;
      case 4:
        return Event.eventClock;
      default:
        return Event.event2by2;
    }
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    switch (obj) {
      case Event.event2by2:
        writer.writeByte(0);
        break;
      case Event.event3by3:
        writer.writeByte(1);
        break;
      case Event.eventPyra:
        writer.writeByte(2);
        break;
      case Event.eventSkewb:
        writer.writeByte(3);
        break;
      case Event.eventClock:
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
