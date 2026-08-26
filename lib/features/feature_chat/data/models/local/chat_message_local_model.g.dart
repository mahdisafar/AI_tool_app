// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageLocalModelAdapter extends TypeAdapter<ChatMessageLocalModel> {
  @override
  final int typeId = 0;

  @override
  ChatMessageLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessageLocalModel(
      isUser: fields[0] as bool,
      text: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessageLocalModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isUser)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
