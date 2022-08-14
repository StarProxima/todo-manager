import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';
import 'package:todo_manager/styles/app_icons.dart';
import 'package:todo_manager/styles/app_theme.dart';
import 'package:todo_manager/ui/home_page/widgets/task_checkbox.dart';

import '../../../models/importance.dart';
import '../../../models/task_model.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({
    required Key key,
    required this.task,
  }) : super(key: key);

  final Task task;
  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  //Легко сказать — «мы должны были сделать вот так» уже после того, как всё закончилось.
  //Однако никто не знает, чем обернётся твой выбор и сколькими жертвами,
  //пока его не сделаешь. А ты должен его сделать!
  final dismissProgress =
      StateProvider.autoDispose.family<double, DismissDirection>(
    (ref, direction) {
      return 0;
    },
  );

  void onUpdate(DismissUpdateDetails details) {
    if (details.direction == DismissDirection.startToEnd) {
      ref.read(dismissProgress(DismissDirection.startToEnd).notifier).state =
          details.progress;
    } else {
      ref.read(dismissProgress(DismissDirection.endToStart).notifier).state =
          details.progress;
    }
  }

  void onDismissed(_) {
    ref.read(taskList.notifier).remove(widget.task);
  }

  Future<bool> confirmDismiss(direction) async {
    switch (direction) {
      case DismissDirection.endToStart:
        return true;

      case DismissDirection.startToEnd:
        await Future.delayed(const Duration(milliseconds: 200));
        changeDone(true);
    }
    return false;
  }

  void changeDone(bool value) {
    ref.read(taskList.notifier).edit(widget.task.editAndCopyWith(done: value));
  }

  void toDetailsPage() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TaskDetailsPage(
    //       task: widget.task,
    //       onSave: widget.onEditTask,
    //       onDelete: widget.onDeleteTask,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dismissible(
      key: widget.key!,
      onUpdate: onUpdate,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      background: Container(
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
      secondaryBackground: Container(
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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: toDetailsPage,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskCheckbox(
              value: widget.task.done,
              task: widget.task,
              onChanged: changeDone,
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
                        style: widget.task.done
                            ? AppTextStyle.crossedOut
                            : Theme.of(context).textTheme.bodyMedium,
                        children: [
                          if (widget.task.importance == Importance.important)
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: AppSvgIcons(
                                  AppSvgIcon.important,
                                  color: widget.task.done
                                      ? AppTextStyle.crossedOut.color
                                      : AppColors.red,
                                ),
                              ),
                            ),
                          if (widget.task.importance == Importance.low)
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: AppSvgIcons(
                                  AppSvgIcon.low,
                                  color: AppTextStyle.crossedOut.color,
                                ),
                              ),
                            ),
                          TextSpan(
                            text: widget.task.text,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.task.deadline != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('dd MMMM yyyy', 'ru_RU')
                            .format(widget.task.deadline!),
                        style: Theme.of(context).textTheme.labelSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 18),
              child: IconButton(
                onPressed: toDetailsPage,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.info_outline,
                  color: Color(0x4d000000),
                ),
              ),
            ),
          ],
        ),
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
