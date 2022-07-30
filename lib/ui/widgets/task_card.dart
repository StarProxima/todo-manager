import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({Key? key, required this.task}) : super(key: key);

  final Task task;
  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isDebug = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: isDebug ? Colors.amber : null,
          child: SizedBox(
            height: 48,
            width: 48,
            child: Checkbox(
              value: widget.task.done,
              onChanged: (value) {
                setState(() {
                  isDebug = !isDebug;
                  widget.task.edit(done: value == true);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  color: isDebug ? Colors.amber : null,
                  child: Text(
                    widget.task.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              widget.task.deadline != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        color: isDebug ? Colors.amber : null,
                        child: Text(
                          DateFormat('dd.MM.yyyy hh:mm')
                              .format(widget.task.deadline!),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 18),
          child: IconButton(
            onPressed: () {},
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Container(
              color: isDebug ? Colors.amber : null,
              child: const Icon(
                Icons.info_outline,
                color: Color(0x4d000000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
