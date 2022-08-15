import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:todo_manager/repositories/tasks_controller.dart';

import '../../generated/l10n.dart';
import '../../models/importance.dart';
import '../../models/task_model.dart';
import '../../styles/app_theme.dart';

part 'widgets/importance_dropdown_button.dart';
part 'widgets/task_details_deadline.dart';
part 'widgets/task_details_text_field.dart';

final _currentTask = StateProvider<Task>((ref) {
  throw UnimplementedError();
});

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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return ProviderScope(
      overrides: [
        _currentTask.overrideWithValue(StateController(task)),
      ],
      child: Consumer(
        builder: (context, ref, _) {
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
                      final editTask =
                          ref.read(_currentTask).edit(text: controller.text);
                      if (widget.task != null) {
                        ref.read(taskList.notifier).edit(editTask);
                      } else {
                        ref.read(taskList.notifier).add(editTask);
                      }
                      Navigator.pop(context);
                    },
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ImportanceDropdownButton(),
                    ),
                    const TaskDetailsDeadline(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete),
                        label: Text(S.of(context).deleteTaskButton),
                        style: TextButton.styleFrom(
                          primary: theme.errorColor,
                        ),
                        onPressed: widget.task != null
                            ? () {
                                ref.read(taskList.notifier).remove(task);
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
        },
      ),
    );
  }
}
