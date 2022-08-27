import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/animated_task_model.dart';
import '../../models/task_filter.dart';
import '../../providers/task_providers/animated_task_list_provider.dart';
import '../../providers/task_providers/dismissible_animated_task_list_provider.dart';
import '../../providers/task_providers/other_task_providers.dart';
import '../../providers/task_providers/task_list_provider.dart';
import '../../router/app_router_delegate.dart';
import '../../styles/app_icons.dart';
import '../../styles/app_theme.dart';
import '../home_page/widgets/task_checkbox.dart';

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
  const TaskCard(
    this.animatedTask, {
    Key? key,
  }) : super(key: key);

  final AnimatedTask animatedTask;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        _currentTaskInTaskCard.overrideWithValue(
          animatedTask.task,
        ),
        _currentTaskStatusInTaskCard
            .overrideWithValue(StateController(animatedTask.status)),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final status = ref.watch(_currentTaskStatusInTaskCard);

          switch (status) {
            case TaskStatus.create:
              return const _TaskCardCreated();
            case TaskStatus.hide:
              return const _TaskCardHidden();
            case TaskStatus.none:
              return const _TaskCardAnimated();
            case TaskStatus.empty:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
