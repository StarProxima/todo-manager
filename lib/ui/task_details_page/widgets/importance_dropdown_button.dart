import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../styles/app_theme.dart';

import '../../../generated/l10n.dart';
import '../../../models/importance.dart';
import '../task_details_page.dart';

class ImportanceDropdownButton extends ConsumerWidget {
  const ImportanceDropdownButton({
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
        Text(
          S.of(context).importance,
        ),
        SizedBox(
          width: 164,
          child: ButtonTheme(
            // alignedDropdown: true,

            child: DropdownButtonHideUnderline(
              child: DropdownButton<Importance>(
                value: importance,
                icon: const SizedBox(),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                elevation: 3,
                items: [
                  DropdownMenuItem<Importance>(
                    value: Importance.basic,
                    child: Text(
                      S.of(context).importanceBasic,
                      style: textTheme.bodySmall,
                    ),
                  ),
                  DropdownMenuItem<Importance>(
                    value: Importance.low,
                    child: Text(
                      S.of(context).importanceLow,
                    ),
                  ),
                  DropdownMenuItem<Importance>(
                    value: Importance.important,
                    child: Text(
                      S.of(context).importanceImportant,
                      style: textTheme.bodyMedium!.copyWith(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
                onChanged: (Importance? value) {
                  if (value != null) {
                    ref.read(currentEditableTask.notifier).state =
                        ref.read(currentEditableTask).edit(importance: value);
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
