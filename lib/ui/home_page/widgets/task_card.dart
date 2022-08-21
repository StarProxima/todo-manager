import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/task_filter.dart';
import '../../../repositories/tasks_controller.dart';
import '../../../styles/app_icons.dart';
import '../../../styles/app_theme.dart';
import 'task_checkbox.dart';
import '../../task_details_page/task_details_page.dart';

import '../../../models/importance.dart';
import '../../../models/task_model.dart';

final _currentTask = Provider<Task>((ref) {
  throw UnimplementedError();
});

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TaskCardState();
  }
}

class _TaskCardState extends ConsumerState<TaskCard> {
  //Легко сказать — «мы должны были сделать вот так» уже после того, как всё закончилось.
  //Однако никто не знает, чем обернётся твой выбор и сколькими жертвами,
  //пока его не сделаешь. А ты должен его сделать!
  final dismissProgress = StateProvider.family<double, DismissDirection>(
    (ref, direction) {
      return 0;
    },
  );

  final resizeDuration = const Duration(milliseconds: 300);
  final movementDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filter = ref.read(taskFilter);

    Future<void> removeTaskAsync() async {
      final controller = ref.read(dismissibleTaskListController.notifier);
      await Future.delayed(resizeDuration);
      controller.dismissDelete(widget.task);
    }

    Future<void> editTaskAsync() async {
      final task = widget.task.edit(done: !widget.task.done);
      if (filter == TaskFilter.uncompleted) {
        final controller = ref.read(dismissibleTaskListController.notifier);
        await Future.delayed(resizeDuration);
        controller.dismissEdit(task);
      } else {
        final taskProvider = ref.read(taskList.notifier);
        await Future.delayed(movementDuration);
        taskProvider.edit(task);
      }
    }

    return Dismissible(
      key: ValueKey(widget.task.id),
      resizeDuration: resizeDuration,
      movementDuration: movementDuration,
      onUpdate: (DismissUpdateDetails details) {
        if (details.direction == DismissDirection.startToEnd) {
          ref
              .read(dismissProgress(DismissDirection.startToEnd).notifier)
              .state = details.progress;
        } else {
          ref
              .read(dismissProgress(DismissDirection.endToStart).notifier)
              .state = details.progress;
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        switch (direction) {
          case DismissDirection.endToStart:
            removeTaskAsync();
            return true;
          case DismissDirection.startToEnd:
            editTaskAsync();
            return filter == TaskFilter.uncompleted;
          default:
            return false;
        }
      },
      background: ColoredBox(
        color: AppColors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return AppDismissIcon(
                  direction: DismissDirection.startToEnd,
                  progress:
                      ref.watch(dismissProgress(DismissDirection.startToEnd)),
                  icon: const Icon(Icons.check, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      secondaryBackground: ColoredBox(
        color: theme.errorColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return AppDismissIcon(
                  direction: DismissDirection.endToStart,
                  progress:
                      ref.watch(dismissProgress(DismissDirection.endToStart)),
                  icon: const Icon(Icons.delete, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      child: ProviderScope(
        //Riverpod принял ислам
        overrides: [
          _currentTask.overrideWithValue(widget.task),
        ],
        child: const _TaskCard(),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  const _TaskCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(_currentTask);

    final crossedOut = Theme.of(context).extension<AppTextStyle>()!.crossedOut!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TaskDetailsPage(
                task: task,
              );
            },
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCheckbox(
            value: task.done,
            task: task,
            onChanged: (value) {
              ref.read(taskList.notifier).edit(task.edit(done: value));
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: task.done
                          ? crossedOut
                          : Theme.of(context).textTheme.bodyMedium,
                      children: [
                        if (task.importance == Importance.important)
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: AppSvgIcons(
                                AppSvgIcon.important,
                                color: task.done
                                    ? crossedOut.color
                                    : AppColors.red,
                              ),
                            ),
                          ),
                        if (task.importance == Importance.low)
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: AppSvgIcons(
                                AppSvgIcon.low,
                                color: crossedOut.color,
                              ),
                            ),
                          ),
                        TextSpan(
                          text: task.text,
                        ),
                      ],
                    ),
                  ),
                ),
                if (task.deadline != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('dd MMMM yyyy', 'ru_RU')
                          .format(task.deadline!),
                      style: Theme.of(context)
                          .extension<AppTextStyle>()!
                          .subtitle!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15, left: 14, right: 18),
            child: Icon(
              Icons.info_outline,
            ),
          ),
        ],
      ),
    );
  }
}

class AppDismissIcon extends StatelessWidget {
  const AppDismissIcon({
    Key? key,
    required this.direction,
    required this.progress,
    required this.icon,
  }) : super(key: key);

  final DismissDirection direction;
  final double progress;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * progress - 47;

    return Padding(
      padding: EdgeInsets.only(
        left: direction == DismissDirection.startToEnd
            ? padding > 24
                ? padding
                : 24
            : 0,
        right: direction == DismissDirection.endToStart
            ? padding > 24
                ? padding
                : 24
            : 0,
      ),
      child: icon,
    );
  }
}
