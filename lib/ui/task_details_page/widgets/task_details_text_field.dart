part of '../task_details_page.dart';

class TaskDetailsTextField extends StatelessWidget {
  const TaskDetailsTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: S.of(context).taskDetailsTextFieldHint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
