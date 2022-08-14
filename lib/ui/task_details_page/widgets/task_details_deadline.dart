import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../generated/l10n.dart';

class TaskDetailsDeadline extends ConsumerStatefulWidget {
  const TaskDetailsDeadline({
    Key? key,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  final DateTime? value;

  final Function(DateTime?) onChanged;
  @override
  ConsumerState<TaskDetailsDeadline> createState() =>
      _TaskDetailsDeadlineState();
}

class _TaskDetailsDeadlineState extends ConsumerState<TaskDetailsDeadline> {
  DateTime? savedDeadline;

  late final activeProvider = StateProvider<bool>((ref) {
    return widget.value != null;
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final deadline = widget.value ?? savedDeadline;
    final active = ref.watch(activeProvider);
    savedDeadline ??= widget.value;
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
                    widget.onChanged(date);
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
            ref.read(activeProvider.notifier).state = value;
            if (value) {
              widget.onChanged(deadline);
            } else {
              widget.onChanged(null);
            }
          },
        ),
      ],
    );
  }
}
