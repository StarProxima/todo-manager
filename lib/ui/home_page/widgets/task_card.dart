import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_manager/ui/task_details_page/task_details_page.dart';
import 'package:todo_manager/styles/app_icons.dart';
import 'package:todo_manager/styles/app_theme.dart';
import 'package:todo_manager/ui/home_page/widgets/task_checkbox.dart';

import '../../../models/importance.dart';
import '../../../models/task_model.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  final void Function(Task) onDelete;
  final void Function(Task) onEdit;
  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool done = widget.task.done;

  ValueNotifier<double> startToEndNotifier = ValueNotifier<double>(0);
  ValueNotifier<double> endToStartNotifier = ValueNotifier<double>(0);

  void onUpdate(details) {
    //Легко сказать — «мы должны были сделать вот так» уже после того, как всё закончилось.
    //Однако никто не знает, чем обернётся твой выбор и сколькими жертвами,
    //пока его не сделаешь. А ты должен его сделать!
    if (details.direction == DismissDirection.startToEnd) {
      startToEndNotifier.value = details.progress;
    } else {
      endToStartNotifier.value = details.progress;
    }
  }

  void onDismissed(_) => widget.onDelete(widget.task);

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
    setState(() {
      done = value;
      widget.onEdit(widget.task.editAndCopyWith(done: value));
    });
  }

  void toDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          task: widget.task,
          onSave: widget.onEdit,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toDetailsPage,
      child: Dismissible(
        key: ValueKey(widget.task.id),
        onUpdate: onUpdate,
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
        background: Container(
          color: AppColors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: startToEndNotifier,
                builder: (BuildContext context, double value, Widget? child) {
                  return AppDismissIcon(
                    direction: DismissDirection.startToEnd,
                    progress: value,
                    icon: const Icon(Icons.check, color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: AppColors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ValueListenableBuilder(
                valueListenable: endToStartNotifier,
                builder: (BuildContext context, double value, Widget? child) {
                  return AppDismissIcon(
                    direction: DismissDirection.endToStart,
                    progress: value,
                    icon: const Icon(Icons.delete, color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskCheckbox(
              value: done,
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
                        style: done
                            ? AppTextStyle.crossedOut
                            : Theme.of(context).textTheme.bodyMedium,
                        children: [
                          if (widget.task.importance != Importance.basic)
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: AppSvgIcons(
                                  widget.task.importance == Importance.important
                                      ? AppSvgIcon.important
                                      : AppSvgIcon.low,
                                  color: done
                                      ? AppTextStyle.crossedOut.color
                                      : null,
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

class AppDismissIcon extends StatefulWidget {
  const AppDismissIcon({
    Key? key,
    required this.direction,
    required this.progress,
    required this.icon,
  }) : super(key: key);

  final DismissDirection direction;
  final double progress;
  final Widget icon;
  @override
  State<AppDismissIcon> createState() => AppDismissIconState();
}

class AppDismissIconState extends State<AppDismissIcon> {
  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * widget.progress - 47;
    return Padding(
      padding: EdgeInsets.only(
        left: widget.direction == DismissDirection.startToEnd
            ? padding > 24
                ? padding
                : 24
            : 0,
        right: widget.direction == DismissDirection.endToStart
            ? padding > 24
                ? padding
                : 24
            : 0,
      ),
      child: widget.icon,
    );
  }
}
