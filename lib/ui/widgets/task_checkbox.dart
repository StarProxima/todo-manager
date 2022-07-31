import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/importance.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/ui/styles/app_theme.dart';

class TaskCheckbox extends StatefulWidget {
  const TaskCheckbox({Key? key, required this.task, required this.onChanged})
      : super(key: key);

  final Task task;
  final void Function(bool) onChanged;
  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  late bool value;
  @override
  Widget build(BuildContext context) {
    value = widget.task.done;
    return GestureDetector(
      onTap: () {
        widget.onChanged(!value);
      },
      child: Container(
        height: 48,
        width: 48,
        color: Colors.transparent,
        child: Container(
          color: !value && widget.task.importance == Importance.important
              ? AppColors.red.withOpacity(0.16)
              : Theme.of(context).scaffoldBackgroundColor,
          margin: const EdgeInsets.all(17),
          child: Checkbox(
            value: value,
            activeColor: AppColors.green,
            fillColor: !value && widget.task.importance == Importance.important
                ? MaterialStateProperty.all(AppColors.red)
                : null,
            onChanged: (_) {
              widget.onChanged(!value);
            },
          ),
        ),
      ),
    );
  }
}
