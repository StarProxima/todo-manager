import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/importance.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:todo_manager/ui/styles/app_icons.dart';
import 'package:todo_manager/ui/styles/app_theme.dart';
import 'package:todo_manager/ui/widgets/task_checkbox.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isDebug = false;
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
