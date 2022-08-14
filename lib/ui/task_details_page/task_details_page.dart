import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';
import 'package:todo_manager/ui/task_details_page/widgets/task_details_deadline.dart';

import '../../models/task_model.dart';
import 'widgets/importance_dropdown_button.dart';
import 'widgets/task_details_text_field.dart';

import '../../generated/l10n.dart';

class TaskDetailsPage extends ConsumerStatefulWidget {
  const TaskDetailsPage({
    Key? key,
    this.task,
  }) : super(key: key);

  final Task? task;

  @override
  ConsumerState<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends ConsumerState<TaskDetailsPage> {
  late Task task = widget.task?.copyWith() ?? Task.create();

  late TextEditingController controller = TextEditingController()
    ..text = widget.task?.text ?? '';

  late final currentTask = StateProvider<Task>((ref) {
    return task;
  });

  void saveTask() {
    final editTask = ref.read(currentTask).edit(text: controller.text);
    if (widget.task != null) {
      ref.read(taskList.notifier).edit(editTask);
    } else {
      ref.read(taskList.notifier).add(editTask);
    }
    Navigator.pop(context);
  }

  void deleteTask() {
    ref.read(taskList.notifier).remove(task);
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
                child: Consumer(
                  builder: (context, ref, child) {
                    return ImportanceDropdownButton(
                      value: ref.watch(
                        currentTask.select((value) => value.importance),
                      ),
                      onChanged: (value) {
                        ref
                            .read(currentTask.notifier)
                            .update((state) => state.edit(importance: value));
                      },
                    );
                  },
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return TaskDetailsDeadline(
                    value: ref.watch(
                      currentTask.select((value) => value.deadline),
                    ),
                    onChanged: (deadline) {
                      ref.read(currentTask.notifier).update(
                        (state) {
                          if (deadline == null) {
                            return state.edit(deleteDeadline: true);
                          } else {
                            return state.edit(deadline: deadline);
                          }
                        },
                      );
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.delete),
                  label: Text(S.of(context).deleteTaskButton),
                  style: TextButton.styleFrom(
                    primary: theme.errorColor,
                  ),
                  onPressed: widget.task != null ? deleteTask : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
