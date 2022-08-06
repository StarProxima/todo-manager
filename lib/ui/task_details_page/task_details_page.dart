import 'package:flutter/material.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_deadline.dart';

import '../../data/models/task_model.dart';
import 'widgets/importance_dropdown_button.dart';
import 'widgets/task_details_text_field.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({
    Key? key,
    required this.task,
    required this.onEdit,
  }) : super(key: key);

  final Task task;

  final Function(Task) onEdit;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task task = widget.task.copyWith();
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
              onPressed: () {
                widget.onEdit(task);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(
                "СОХРАНИТЬ",
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
                text: widget.task.text,
                onChanged: (text) {
                  task = task.editAndCopyWith(text: text);
                },
              ),
              const SizedBox(
                height: 28,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ImportanceDropdownButton(
                  value: widget.task.importance,
                  onChanged: (value) {
                    task = task.editAndCopyWith(importance: value);
                  },
                ),
              ),
              TaskDetailsDeadline(
                value: widget.task.deadline,
                onChanged: (deadline) {
                  if (deadline == null) {
                    task = task.editAndCopyWith(deleteDeadline: true);
                  } else {
                    task = task.editAndCopyWith(deadline: deadline);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
