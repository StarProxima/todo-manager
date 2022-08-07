import 'package:flutter/material.dart';
import 'package:todo_manager/ui/styles/app_theme.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_deadline.dart';

import '../../data/models/task_model.dart';
import 'widgets/importance_dropdown_button.dart';
import 'widgets/task_details_text_field.dart';

import '../../generated/l10n.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({
    Key? key,
    this.task,
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  final Task? task;

  final void Function(Task) onSave;
  final void Function(Task)? onDelete;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task task =
      widget.task != null ? widget.task!.copyWith() : Task.create();

  late TextEditingController controller = TextEditingController()
    ..text = widget.task?.text ?? '';

  void saveTask() {
    widget.onSave(task.editAndCopyWith(text: controller.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 4,
        elevation: 0,
        leading: SizedBox(
          height: 14,
          width: 14,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: saveTask,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                S.of(context).taskDetailsSave,
                style: textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Column(
            children: [
              TaskDetailsTextField(
                controller: controller,
              ),
              const SizedBox(
                height: 28,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ImportanceDropdownButton(
                  value: task.importance,
                  onChanged: (value) {
                    task = task.editAndCopyWith(importance: value);
                  },
                ),
              ),
              TaskDetailsDeadline(
                value: task.deadline,
                onChanged: (deadline) {
                  if (deadline == null) {
                    task = task.editAndCopyWith(deleteDeadline: true);
                  } else {
                    task = task.editAndCopyWith(deadline: deadline);
                  }
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: Text(S.of(context).deleteTaskButton),
                  style: TextButton.styleFrom(
                    primary: AppColors.red,
                  ),
                  onPressed: widget.task != null
                      ? () {
                          widget.onDelete?.call(widget.task!);
                          Navigator.pop(context);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
