// ignore_for_file: public_member_api_docs, sort_constructors_first

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
