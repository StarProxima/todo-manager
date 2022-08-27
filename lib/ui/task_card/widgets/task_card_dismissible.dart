part of '../task_card.dart';

class _TaskCardDismissible extends ConsumerStatefulWidget {
  const _TaskCardDismissible({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TaskCardDismissibleState();
  }
}

class _TaskCardDismissibleState extends ConsumerState<_TaskCardDismissible> {
  //Легко сказать — «мы должны были сделать вот так» уже после того, как всё закончилось.
  //Однако никто не знает, чем обернётся твой выбор и сколькими жертвами,
  //пока его не сделаешь. А ты должен его сделать!
  final dismissProgress = StateProvider.family<double, DismissDirection>(
    (ref, direction) {
      return 0;
    },
  );

  final resizeDuration = const Duration(milliseconds: 300);
  final movementDuration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = ref.watch(_currentTaskInTaskCard);

    Future<void> removeTaskAsync() async {
      final controller = ref.read(dismissibleTaskListController.notifier);

      await Future.delayed(resizeDuration);

      controller.dismissDelete(task);
    }

    Future<void> editTaskAsync() async {
      final editedTask = task.edit(done: !task.done);
      if (ref.read(taskFilter) == TaskFilter.uncompleted) {
        final controller = ref.read(dismissibleTaskListController.notifier);

        await Future.delayed(resizeDuration);
        controller.dismissEdit(editedTask);
      } else {
        final taskProvider = ref.read(taskList.notifier);
        await Future.delayed(movementDuration);
        taskProvider.edit(editedTask);
      }
    }

    return Dismissible(
      key: ValueKey(task.id),
      resizeDuration: resizeDuration,
      movementDuration: movementDuration,
      onUpdate: (DismissUpdateDetails details) {
        if (details.direction == DismissDirection.startToEnd) {
          ref
              .read(dismissProgress(DismissDirection.startToEnd).notifier)
              .state = details.progress;
        } else {
          ref
              .read(dismissProgress(DismissDirection.endToStart).notifier)
              .state = details.progress;
        }
      },
      confirmDismiss: (DismissDirection direction) async {
        switch (direction) {
          case DismissDirection.endToStart:
            removeTaskAsync();
            return true;
          case DismissDirection.startToEnd:
            editTaskAsync();
            return ref.read(taskFilter) == TaskFilter.uncompleted;
          default:
            return false;
        }
      },
      background: ColoredBox(
        color: AppColors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return _TaskCardDismissIcon(
                  direction: DismissDirection.startToEnd,
                  progress:
                      ref.watch(dismissProgress(DismissDirection.startToEnd)),
                  icon: const Icon(Icons.check, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      secondaryBackground: ColoredBox(
        color: theme.errorColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return _TaskCardDismissIcon(
                  direction: DismissDirection.endToStart,
                  progress:
                      ref.watch(dismissProgress(DismissDirection.endToStart)),
                  icon: const Icon(Icons.delete, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
      child: const TaskCardView(),
    );
  }
}
