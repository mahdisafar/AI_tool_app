// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_archive_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatArchiveLocalModelAdapter extends TypeAdapter<ChatArchiveLocalModel> {
  @override
  final int typeId = 101;

  @override
  ChatArchiveLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatArchiveLocalModel(
      id: fields[0] as String,
      chat: (fields[1] as List).cast<ChatMessageLocalModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatArchiveLocalModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatArchiveLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
