import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../router/app_router_delegate.dart';
import 'widgets/task_details_deadline.dart';

import '../../models/task_model.dart';
import 'widgets/importance_dropdown_button.dart';
import 'widgets/task_details_text_field.dart';

import '../../generated/l10n.dart';

final currentEditableTask = StateProvider.autoDispose<Task>((ref) {
  return Task.create();
});

class TaskDetails extends ConsumerWidget {
  const TaskDetails({Key? key, this.task}) : super(key: key);

  final Task? task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        currentEditableTask.overrideWithValue(
          StateController(task ?? Task.create()),
        ),
      ],
      child: const _TaskDetailsPage(),
    );
  }
}

class _TaskDetailsPage extends ConsumerStatefulWidget {
  const _TaskDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends ConsumerState<_TaskDetailsPage> {
  late bool isNewTask = ref
      .read(taskList)
      .where((element) => element.id == ref.read(currentEditableTask).id)
      .isEmpty;

  late TextEditingController controller = TextEditingController()
    ..text = ref.read(currentEditableTask).text;

  void pop() {
    (Router.of(context).routerDelegate as AppRouterDelegate).gotoHomePage();
  }

  void saveTask() {
    final editedTask =
        ref.read(currentEditableTask).edit(text: controller.text);
    final notifier = ref.read(taskList.notifier);
    if (isNewTask) {
      notifier.add(editedTask);
    } else {
      notifier.edit(editedTask);
    }
    pop();
  }

  void deleteTask() {
    ref.read(taskList.notifier).delete(ref.read(currentEditableTask));
    pop();
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
            splashRadius: 25,
            onPressed: pop,
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: SizedBox(
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
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
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
                onPressed: !isNewTask ? deleteTask : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
