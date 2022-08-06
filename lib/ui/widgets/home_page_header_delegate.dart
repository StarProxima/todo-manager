import 'package:flutter/material.dart';

class HomePageHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomePageHeaderDelegate({
    required this.completedTaskCount,
    required this.onChangeVisibilityCompletedTask,
  });

  final int completedTaskCount;

  final Function(bool) onChangeVisibilityCompletedTask;

  static const double expandedHeight = 200;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double diff = expandedHeight - kToolbarHeight;
    double t = (diff - shrinkOffset) / diff;
    double percentOfShrinkOffset = t > 0 ? t : 0;
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;
    return Material(
      color: theme.scaffoldBackgroundColor,
      elevation:
          percentOfShrinkOffset <= 0.05 ? 5 - 100 * percentOfShrinkOffset : 0,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16,
          right: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 16 + 26 * percentOfShrinkOffset,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 16 + 44 * percentOfShrinkOffset,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Мои дела",
                      style: textTheme.headlineLarge!.copyWith(
                        fontSize: 20 + 12 * percentOfShrinkOffset,
                      ),
                    ),
                    if (percentOfShrinkOffset > 0)
                      Padding(
                        padding:
                            EdgeInsets.only(top: 6 * percentOfShrinkOffset),
                        child: Opacity(
                          opacity: percentOfShrinkOffset,
                          child: Text(
                            "Выполнено - $completedTaskCount",
                            style: textTheme.bodySmall!.copyWith(
                              fontSize: 20 * percentOfShrinkOffset,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                VisibilityButton(
                  value: false,
                  onChangeVisibilityCompletedTask: (value) {
                    onChangeVisibilityCompletedTask(value);
                  },
                ),
                SizedBox(
                  height: 16 + 2 * percentOfShrinkOffset,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class VisibilityButton extends StatefulWidget {
  const VisibilityButton({
    Key? key,
    required this.value,
    required this.onChangeVisibilityCompletedTask,
  }) : super(key: key);

  final bool value;
  final Function(bool) onChangeVisibilityCompletedTask;
  @override
  State<VisibilityButton> createState() => _VisibilityButtonState();
}

class _VisibilityButtonState extends State<VisibilityButton> {
  late bool value = widget.value;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 28,
        onPressed: () {
          value = !value;
          widget.onChangeVisibilityCompletedTask(value);
          setState(() {});
        },
        icon: value
            ? Icon(
                Icons.visibility,
                size: 24,
                color: theme.primaryColor,
              )
            : Icon(
                Icons.visibility_off,
                size: 24,
                color: theme.primaryColor,
              ),
      ),
    );
  }
}
