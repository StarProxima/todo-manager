import 'package:flutter/material.dart';

class TaskDetailsTextField extends StatelessWidget {
  TaskDetailsTextField({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: controller,
          minLines: 4,
          maxLines: null,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: "Что надо сделать...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
