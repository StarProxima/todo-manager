import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/importance.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_manager/ui/styles/app_icons.dart';
import 'package:todo_manager/ui/styles/app_theme.dart';
import 'package:todo_manager/ui/widgets/task_checkbox.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key, required this.task, this.onDelete})
      : super(key: key);

  final Function()? onDelete;
  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isDebug = false;

  GlobalKey<AppDismissBackgroundState> dismissStartToEndKey =
      GlobalKey<AppDismissBackgroundState>();

  GlobalKey<AppDismissBackgroundState> dismissEndToStartKey =
      GlobalKey<AppDismissBackgroundState>();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),
      onDismissed: (_) {
        widget.onDelete?.call();
      },
      confirmDismiss: (direction) async {
        switch (direction) {
          case DismissDirection.endToStart:
            return true;

          case DismissDirection.startToEnd:
            setState(() {
              widget.task.done = true;
            });
            break;

          default:
            break;
        }
        return false;
      },
      onUpdate: (details) {
        //Ужас, помогите
        if (details.direction == DismissDirection.startToEnd) {
          dismissStartToEndKey.currentState?.setProgress(details.progress);
        } else {
          dismissEndToStartKey.currentState?.setProgress(details.progress);
        }
      },
      background: Container(
        color: AppColors.green,
        child: Row(
          children: [
            AppDismissBackground(
              key: dismissStartToEndKey,
              direction: DismissDirection.startToEnd,
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: AppColors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppDismissBackground(
              key: dismissEndToStartKey,
              direction: DismissDirection.endToStart,
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCheckbox(
            task: widget.task,
            onChanged: (value) {
              setState(() {
                widget.task.done = value;
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    color: isDebug ? Colors.amber : null,
                    child: RichText(
                      text: TextSpan(
                        style: widget.task.done
                            ? AppTextStyle.crossedOut
                            : Theme.of(context).textTheme.bodyMedium,
                        children: [
                          widget.task.importance != Importance.basic
                              ? WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: AppSvgIcons(
                                      widget.task.importance ==
                                              Importance.important
                                          ? AppSvgIcon.important
                                          : AppSvgIcon.low,
                                      color: widget.task.done
                                          ? AppTextStyle.crossedOut.color
                                          : null,
                                    ),
                                  ),
                                )
                              : const TextSpan(),
                          TextSpan(
                            text: widget.task.text,
                            style: widget.task.done
                                ? AppTextStyle.crossedOut
                                : Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                widget.task.deadline != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          color: isDebug ? Colors.amber : null,
                          child: Text(
                            DateFormat('dd.MM.yyyy hh:mm')
                                .format(widget.task.deadline!),
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 14, right: 18),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isDebug = !isDebug;
                });
              },
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Container(
                color: isDebug ? Colors.amber : null,
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0x4d000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDismissBackground extends StatefulWidget {
  const AppDismissBackground({
    Key? key,
    required this.direction,
    required this.icon,
  }) : super(key: key);

  final DismissDirection direction;
  final Widget icon;
  @override
  State<AppDismissBackground> createState() => AppDismissBackgroundState();
}

class AppDismissBackgroundState extends State<AppDismissBackground> {
  void setProgress(double progress) {
    setState(() {
      padding = MediaQuery.of(context).size.width * progress - 48;
    });
  }

  double padding = 0;

  @override
  Widget build(BuildContext context) {
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
