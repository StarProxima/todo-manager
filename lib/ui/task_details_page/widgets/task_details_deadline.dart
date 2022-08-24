import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';
import '../task_details_page.dart';

class TaskDetailsDeadline extends ConsumerStatefulWidget {
  const TaskDetailsDeadline({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TaskDetailsDeadline> createState() =>
      _TaskDetailsDeadlineState();
}

class _TaskDetailsDeadlineState extends ConsumerState<TaskDetailsDeadline>
    with SingleTickerProviderStateMixin {
  DateTime? savedDeadline;

  late final activeProvider = StateProvider<bool?>((ref) {
    return null;
  });

  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    final deadline =
        ref.watch(currentEditableTask.select((value) => value.deadline));

    savedDeadline = deadline ?? savedDeadline;

    ref
        .read(activeProvider.notifier)
        .update((state) => state ?? deadline != null);

    final active = ref.watch(activeProvider);

    if (active!) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          highlightColor: theme.primaryColor.withOpacity(0.25),
          onTap: () async {
            var date = await showDatePicker(
              context: context,
              initialDate: deadline ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              savedDeadline = date;
              ref.read(activeProvider.notifier).state = true;
              ref.read(currentEditableTask.notifier).state =
                  ref.read(currentEditableTask).edit(deadline: date);
            }
          },
          child: SizedBox(
            height: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).deadlineTitle,
                ),
                SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeInOut,
                  ),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeInQuad,
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: const Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Text(
                        savedDeadline != null
                            ? DateFormat('dd MMMM yyyy').format(savedDeadline!)
                            : S.of(context).deadlineNotSet,
                        style: textTheme.bodyMedium!.copyWith(
                          color: savedDeadline != null
                              ? theme.primaryColor
                              : textTheme.bodySmall!.color,
                        ),
                      ),
                    ),
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
            ref.read(activeProvider.notifier).state = value;
            ref.read(currentEditableTask.notifier).state =
                ref.read(currentEditableTask).edit(
                      deleteDeadline: !value,
                      deadline: savedDeadline,
                    );
          },
        ),
      ],
    );
  }
}
