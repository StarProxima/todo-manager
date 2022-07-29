import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/task_model.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: widget.task.done,
          onChanged: (value) {
            setState(() {
              widget.task.edit(done: value == true);
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.task.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 14, right: 18),
          child: IconButton(
            onPressed: () {},
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.info_outline,
              color: Color(0x4d000000),
            ),
          ),
        ),
      ],
    );
  }
}
