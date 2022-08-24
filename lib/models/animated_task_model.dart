// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../ui/task_card/task_card.dart';
import 'task_model.dart';

part 'animated_task_model.freezed.dart';

@freezed
class AnimatedTask with _$AnimatedTask {
  const AnimatedTask._();

  const factory AnimatedTask({
    required TaskStatus status,
    required Task task,
  }) = _AnimatedTask;
}

class Data {
  DateTime? date;
  Data({
    this.date,
  });

  Data copyWith({
    DateTime? date,
  }) {
    return Data(
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Data(date: $date)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.date == date;
  }

  @override
  int get hashCode => date.hashCode;
}
