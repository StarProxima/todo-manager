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
  late bool value = widget.task.done;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!value);
        setState(() {
          value = !value;
        });
      },
      child: Container(
        height: 48,
        width: 48,
        color: Colors.transparent,
        child: Container(
          color: widget.task.importance == Importance.important
              ? AppColors.red.withOpacity(0.16)
              : null,
          margin: const EdgeInsets.all(17),
          child: Checkbox(
            activeColor: value ? AppColors.green : null,
            fillColor: !value && widget.task.importance == Importance.important
                ? MaterialStateProperty.all(AppColors.red)
                : null,
            value: value,
            onChanged: (_) {
              widget.onChanged(!value);
              setState(() {
                value = !value;
              });
            },
          ),
        ),
      ),
    );
  }
}
