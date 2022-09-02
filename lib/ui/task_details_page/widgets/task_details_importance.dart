import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';
import '../../../models/importance.dart';
import '../../../styles/app_theme.dart';
import '../task_details_page.dart';

class TaskDetailsImportance extends ConsumerWidget {
  const TaskDetailsImportance({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    final importance =
        ref.watch(currentEditableTask.select((value) => value.importance));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 164,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: PopupMenuButton<Importance>(
              tooltip: '',
              constraints: const BoxConstraints(
                minWidth: 164,
              ),
              child: SizedBox(
                width: Size.infinite.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).importance,
                    ),
                    _ImportanceText(importance: importance),
                  ],
                ),
              ),
              onSelected: (Importance item) {
                ref.read(currentEditableTask.notifier).update(
                      (state) => state.edit(importance: item),
                    );
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<Importance>>[
                for (final importanceValue in Importance.values)
                  PopupMenuItem<Importance>(
                    value: importanceValue,
                    child: _ImportanceText(importance: importanceValue),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _ImportanceText extends StatelessWidget {
  const _ImportanceText({Key? key, required this.importance}) : super(key: key);

  final Importance importance;

  @override
  Widget build(BuildContext context) {
    switch (importance) {
      case Importance.low:
        return Text(
          S.of(context).importanceLow,
          style:
              Theme.of(context).extension<AppTextStyle>()?.crossedOut?.copyWith(
                    decoration: TextDecoration.none,
                  ),
        );
      case Importance.basic:
        return Text(
          S.of(context).importanceBasic,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      case Importance.important:
        return Text(
          S.of(context).importanceImportant,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.red,
              ),
        );
    }
  }
}
