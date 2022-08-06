import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailsDeadline extends StatefulWidget {
  const TaskDetailsDeadline({
    Key? key,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  final DateTime? value;

  final Function(DateTime?) onChanged;
  @override
  State<TaskDetailsDeadline> createState() => _TaskDetailsDeadlineState();
}

class _TaskDetailsDeadlineState extends State<TaskDetailsDeadline> {
  late DateTime? value = widget.value;

  late bool active = widget.value != null;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: active
              ? () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      value = date;
                      widget.onChanged(value);
                    });
                  }
                }
              : null,
          child: SizedBox(
            height: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Сделать до',
                ),
                if (active)
                  Text(
                    value != null
                        ? DateFormat('dd.MM.yyyy hh:mm').format(value!)
                        : 'Не задано',
                    style: textTheme.bodyMedium!.copyWith(
                      color: value != null
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
            setState(() {
              active = value;
            });

            if (value) {
              widget.onChanged(this.value);
            } else {
              widget.onChanged(null);
            }
          },
        ),
      ],
    );
  }
}
