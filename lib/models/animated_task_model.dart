// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_model.dart';

part 'animated_task_model.freezed.dart';

enum TaskCardAnimation {
  show,
  hide,
  basic,
  empty,
}

enum TaskCardPosition {
  top,
  middle,
  bottom,
}

@freezed
class AnimatedTask with _$AnimatedTask {
  const AnimatedTask._();

  const factory AnimatedTask({
    required TaskCardAnimation animation,
    required TaskCardPosition position,
    required Task task,
  }) = _AnimatedTask;
}
