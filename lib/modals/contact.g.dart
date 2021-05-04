// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactsModalAdapter extends TypeAdapter<ContactsModal> {
  @override
  final int typeId = 0;

  @override
  ContactsModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactsModal(
      number: fields[0] as String,
      photo: fields[1] as String,
      uid: fields[2] as String,
      username: fields[3] as String,
      contactName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactsModal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.photo)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.contactName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactsModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
