import 'package:flutter/material.dart';
import '../../../styles/app_theme.dart';

import '../../../models/importance.dart';
import '../../../models/task_model.dart';

class TaskCheckbox extends StatefulWidget {
  const TaskCheckbox({
    Key? key,
    required this.task,
    required this.onChanged,
    required this.value,
  }) : super(key: key);

  final Task task;
  final bool value;
  final void Function(bool) onChanged;
  @override
  State<TaskCheckbox> createState() => _TaskCheckboxState();
}

class _TaskCheckboxState extends State<TaskCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        height: 48,
        width: 48,
        color: Colors.transparent,
        padding: const EdgeInsets.all(17),
        child: ColoredBox(
          color: !widget.value && widget.task.importance == Importance.important
              ? AppColors.red.withOpacity(0.16)
              : Colors.transparent,
          child: Checkbox(
            value: widget.value,
            activeColor: AppColors.green,
            fillColor:
                !widget.value && widget.task.importance == Importance.important
                    ? MaterialStateProperty.all(AppColors.red)
                    : null,
            onChanged: (_) {
              widget.onChanged(!widget.value);
            },
          ),
        ),
      ),
    );
  }
}
