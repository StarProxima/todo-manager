import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_manager/models/task_filter.dart';
import 'package:todo_manager/repositories/tasks_controller.dart';

import '../../../generated/l10n.dart';

class HomePageHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomePageHeaderDelegate();

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
    log('HomePageHeaderDelegate');
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
                      S.of(context).homePageTitle,
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
                          child: Consumer(
                            builder: (context, ref, child) => Text(
                              S.of(context).homePageSubTitle(
                                    ref.watch(completedTaskCount),
                                  ),
                              style: textTheme.bodySmall!.copyWith(
                                fontSize: 20 * percentOfShrinkOffset,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                const VisibilityButton(),
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

class VisibilityButton extends ConsumerWidget {
  const VisibilityButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = Theme.of(context);
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        padding: EdgeInsets.zero,
        splashRadius: 28,
        onPressed: () {
          ref.read(taskFilter.notifier).update(
                (state) => state == TaskFilter.all
                    ? TaskFilter.uncompleted
                    : TaskFilter.all,
              );
        },
        icon: ref.watch(taskFilter) == TaskFilter.all
            ? Icon(
                Icons.visibility_off,
                size: 24,
                color: theme.primaryColor,
              )
            : Icon(
                Icons.visibility,
                size: 24,
                color: theme.primaryColor,
              ),
      ),
    );
  }
}
