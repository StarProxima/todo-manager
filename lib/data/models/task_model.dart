// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class Task {
  late final String id;
  String text;
  Importance importance;
  bool done;
  DateTime? deadline;
  Color? color;
  late final DateTime createdAt;
  late DateTime changedAt;
  late String lastUpdatedBy;

  Task({
    required this.text,
    required this.importance,
    this.deadline,
    required this.done,
    this.color,
  }) {
    // ? Generate unique id
    id = DateTime.now().millisecondsSinceEpoch.toString();
    createdAt = DateTime.now();
    changedAt = DateTime.now();
    lastUpdatedBy = 'Pacman';
  }

  Task.full({
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
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
      color: color ?? this.color,
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
    return Task.full(
      id: map['id'] as String,
      text: map['text'] as String,
      importance: (map['importance'] as String).toImportance(),
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

extension StringToEnum on String {
  Importance toImportance() {
    return Importance.values.firstWhere(
      (element) => element.name == this,
      orElse: () => throw Exception('Unknown importance $this'),
    );
  }
}
