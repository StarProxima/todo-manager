part of '../task_details_page.dart';

class TaskDetailsDeadline extends ConsumerStatefulWidget {
  const TaskDetailsDeadline({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TaskDetailsDeadline> createState() =>
      _TaskDetailsDeadlineState();
}

class _TaskDetailsDeadlineState extends ConsumerState<TaskDetailsDeadline> {
  DateTime? savedDeadline;

  late final activeProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final deadline =
        ref.watch(_currentTask.select((value) => value.deadline)) ??
            savedDeadline;
    final active =
        ref.watch(_currentTask.select((value) => value.deadline)) != null;
    savedDeadline ??= deadline;
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: active
              ? () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: deadline ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    savedDeadline = date;
                    ref
                        .read(_currentTask.notifier)
                        .update((state) => state.edit(deadline: date));
                  }
                }
              : null,
          child: SizedBox(
            height: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).deadlineTitle,
                ),
                if (active)
                  Text(
                    deadline != null
                        ? DateFormat('dd MMMM yyyy').format(deadline)
                        : S.of(context).deadlineNotSet,
                    style: textTheme.bodyMedium!.copyWith(
                      color: deadline != null
                          ? theme.primaryColor
                          : textTheme.bodySmall!.color,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Switch(
          value: active,
          onChanged: (value) {
            if (value) {
              ref
                  .read(_currentTask.notifier)
                  .update((state) => state.edit(deadline: deadline));
            } else {
              ref
                  .read(_currentTask.notifier)
                  .update((state) => state.edit(deleteDeadline: null));
            }
          },
        ),
      ],
    );
  }
}
