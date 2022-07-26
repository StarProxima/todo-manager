import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String text;
  Importance importance;
  DateTime? deadline;
  bool done;
  Color? color;
  DateTime createdAt;
  DateTime changedAt;
  String lastUpdatedBy;

  Task({
    required this.id,
    required this.text,
    required this.importance,
    this.deadline,
    required this.done,
    this.color,
    required this.createdAt,
    required this.changedAt,
    required this.lastUpdatedBy,
  });

  Task copyWith({
    String? id,
    String? text,
    Importance? importance,
    DateTime? deadline,
    bool? done,
    Color? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'importance': importance.name,
      'deadline': deadline?.millisecondsSinceEpoch,
      'done': done,
      'color': color?.value,
      'created_at': createdAt.millisecondsSinceEpoch,
      'changed_at': changedAt.millisecondsSinceEpoch,
      'last_updated_by': lastUpdatedBy,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      text: map['text'] as String,
      importance:
          EnumToString.fromString(Importance.values, map['importance']) ??
              Importance.basic,
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int)
          : null,
      done: map['done'] as bool,
      color: map['color'] != null ? Color(map['color'] as int) : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      changedAt: DateTime.fromMillisecondsSinceEpoch(map['changed_at'] as int),
      lastUpdatedBy: map['last_updated_by'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Task(id: $id, text: $text, importance: $importance, deadline: $deadline, done: $done, color: $color, created_at: $createdAt, changed_at: $changedAt, last_updated_by: $lastUpdatedBy)';
  }
}

enum Importance {
  low,
  basic,
  important,
}
