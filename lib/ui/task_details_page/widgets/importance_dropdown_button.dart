import 'package:flutter/material.dart';
import 'package:todo_manager/styles/app_theme.dart';

import '../../../generated/l10n.dart';
import '../../../models/importance.dart';

class ImportanceDropdownButton extends StatefulWidget {
  const ImportanceDropdownButton({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final Importance value;
  final void Function(Importance) onChanged;

  @override
  State<ImportanceDropdownButton> createState() =>
      _ImportanceDropdownButtonState();
}

class _ImportanceDropdownButtonState extends State<ImportanceDropdownButton> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

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
                value: widget.value,
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
                    widget.onChanged(value);
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
