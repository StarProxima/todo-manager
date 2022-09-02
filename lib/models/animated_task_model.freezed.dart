// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'animated_task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AnimatedTask {
  TaskStatus get status => throw _privateConstructorUsedError;
  Task get task => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnimatedTaskCopyWith<AnimatedTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnimatedTaskCopyWith<$Res> {
  factory $AnimatedTaskCopyWith(
          AnimatedTask value, $Res Function(AnimatedTask) then) =
      _$AnimatedTaskCopyWithImpl<$Res>;
  $Res call({TaskStatus status, Task task});

  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class _$AnimatedTaskCopyWithImpl<$Res> implements $AnimatedTaskCopyWith<$Res> {
  _$AnimatedTaskCopyWithImpl(this._value, this._then);

  final AnimatedTask _value;
  // ignore: unused_field
  final $Res Function(AnimatedTask) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? task = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      task: task == freezed
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }

  @override
  $TaskCopyWith<$Res> get task {
    return $TaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc
abstract class _$$_AnimatedTaskCopyWith<$Res>
    implements $AnimatedTaskCopyWith<$Res> {
  factory _$$_AnimatedTaskCopyWith(
          _$_AnimatedTask value, $Res Function(_$_AnimatedTask) then) =
      __$$_AnimatedTaskCopyWithImpl<$Res>;
  @override
  $Res call({TaskStatus status, Task task});

  @override
  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class __$$_AnimatedTaskCopyWithImpl<$Res>
    extends _$AnimatedTaskCopyWithImpl<$Res>
    implements _$$_AnimatedTaskCopyWith<$Res> {
  __$$_AnimatedTaskCopyWithImpl(
      _$_AnimatedTask _value, $Res Function(_$_AnimatedTask) _then)
      : super(_value, (v) => _then(v as _$_AnimatedTask));

  @override
  _$_AnimatedTask get _value => super._value as _$_AnimatedTask;

  @override
  $Res call({
    Object? status = freezed,
    Object? task = freezed,
  }) {
    return _then(_$_AnimatedTask(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      task: task == freezed
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task,
    ));
  }
}

/// @nodoc

class _$_AnimatedTask extends _AnimatedTask {
  const _$_AnimatedTask({required this.status, required this.task}) : super._();

  @override
  final TaskStatus status;
  @override
  final Task task;

  @override
  String toString() {
    return 'AnimatedTask(status: $status, task: $task)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AnimatedTask &&
            const DeepCollectionEquality().equals(other.status, status) &&
            const DeepCollectionEquality().equals(other.task, task));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      const DeepCollectionEquality().hash(task));

  @JsonKey(ignore: true)
  @override
  _$$_AnimatedTaskCopyWith<_$_AnimatedTask> get copyWith =>
      __$$_AnimatedTaskCopyWithImpl<_$_AnimatedTask>(this, _$identity);
}

abstract class _AnimatedTask extends AnimatedTask {
  const factory _AnimatedTask(
      {required final TaskStatus status,
      required final Task task}) = _$_AnimatedTask;
  const _AnimatedTask._() : super._();

  @override
  TaskStatus get status;
  @override
  Task get task;
  @override
  @JsonKey(ignore: true)
  _$$_AnimatedTaskCopyWith<_$_AnimatedTask> get copyWith =>
      throw _privateConstructorUsedError;
}
