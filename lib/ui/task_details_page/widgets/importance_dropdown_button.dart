part of '../task_details_page.dart';

class ImportanceDropdownButton extends ConsumerWidget {
  const ImportanceDropdownButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    final importance =
        ref.watch(_currentTask.select((value) => value.importance));

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
                  ref
                      .read(_currentTask.notifier)
                      .update((state) => state.edit(importance: value));
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
