import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_providers/dismissible_animated_task_list_provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'widgets/floating_action_panel.dart';
import 'widgets/home_page_header_delegate.dart';
import '../task_card/task_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final animatedTasks = ref.watch(dismissibleAnimatedTaskList);
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HomePageHeaderDelegate(
                    orientation == Orientation.portrait ? 200 : 125,
                  ),
                ),
                SliverStack(
                  children: [
                    SliverPositioned.fill(
                      bottom: -16,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 2),
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRect(
                              child: TaskCard(
                                animatedTasks[index],
                              ),
                            ),
                          );
                        },
                        childCount: animatedTasks.length,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: const FloatingActionPanel(),
    );
  }
}
