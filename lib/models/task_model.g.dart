// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<_$_Task> {
  @override
  final int typeId = 0;

  @override
  _$_Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_Task(
      id: fields[0] as String,
      text: fields[1] as String,
      done: fields[2] as bool,
      importance: fields[3] as Importance,
      deadline: fields[4] as DateTime?,
      createdAt: fields[6] as DateTime,
      changedAt: fields[7] as DateTime,
      lastUpdatedBy: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$_Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.done)
      ..writeByte(3)
      ..write(obj.importance)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.changedAt)
      ..writeByte(8)
      ..write(obj.lastUpdatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Task _$$_TaskFromJson(Map<String, dynamic> json) => _$_Task(
      id: json['id'] as String,
      text: json['text'] as String,
      done: json['done'] as bool,
      importance: $enumDecode(_$ImportanceEnumMap, json['importance']),
      deadline:
          const TimestampOrNullConverter().fromJson(json['deadline'] as int?),
      createdAt: const TimestampConverter().fromJson(json['created_at'] as int),
      changedAt: const TimestampConverter().fromJson(json['changed_at'] as int),
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$_TaskToJson(_$_Task instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'done': instance.done,
      'importance': _$ImportanceEnumMap[instance.importance]!,
      'deadline': const TimestampOrNullConverter().toJson(instance.deadline),
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'changed_at': const TimestampConverter().toJson(instance.changedAt),
      'last_updated_by': instance.lastUpdatedBy,
    };

const _$ImportanceEnumMap = {
  Importance.low: 'low',
  Importance.basic: 'basic',
  Importance.important: 'important',
};
