// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModalAdapter extends TypeAdapter<MessageModal> {
  @override
  final int typeId = 1;

  @override
  MessageModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModal(
      message: fields[0] as String,
      read: fields[5] as bool,
      receiver: fields[3] as String,
      sender: fields[2] as String,
      time: fields[4] as int,
      type: fields[1] as String,
      delivered: fields[7] as bool,
      sent: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.sender)
      ..writeByte(3)
      ..write(obj.receiver)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.read)
      ..writeByte(6)
      ..write(obj.sent)
      ..writeByte(7)
      ..write(obj.delivered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
