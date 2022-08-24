import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers.dart';
import '../../models/task_filter.dart';
import '../../styles/app_icons.dart';
import '../../styles/app_theme.dart';
import '../home_page/widgets/task_checkbox.dart';
import '../task_details_page/task_details_page.dart';

import '../../models/importance.dart';
import '../../models/task_model.dart';

part 'widgets/task_card_hidden.dart';
part 'widgets/task_card_created.dart';
part 'widgets/task_card_animated.dart';
part 'widgets/task_card_dismissible.dart';
part 'widgets/task_card_view.dart';
part 'widgets/task_card_dismiss_icon.dart';

final _currentTaskInTaskCard = Provider<Task>((ref) {
  throw UnimplementedError();
});

final _currentTaskStatusInTaskCard = StateProvider<TaskStatus>((ref) {
  throw UnimplementedError();
});

enum TaskStatus {
  create,
  hide,
  none,
  empty,
}

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task, this.status}) : super(key: key);

  final Task task;

  final TaskStatus? status;
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        _currentTaskInTaskCard.overrideWithValue(
          task,
        ),
        _currentTaskStatusInTaskCard
            .overrideWithValue(StateController(status ?? TaskStatus.none)),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final status = ref.watch(_currentTaskStatusInTaskCard);

          return status == TaskStatus.create
              ? const _TaskCardCreated()
              : status == TaskStatus.hide
                  ? const TaskCardHidden()
                  : status == TaskStatus.none
                      ? const _TaskCardAnimated()
                      : const SizedBox();
        },
      ),
    );
  }
}
