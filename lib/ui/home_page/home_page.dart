import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import 'widgets/add_task_card.dart';

import '../../models/task_model.dart';
import 'widgets/floating_action_panel.dart';
import 'widgets/home_page_header_delegate.dart';
import '../task_card/task_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  List<String> tasksToId(List<Task> list) {
    return List.generate(list.length, (index) {
      return list[index].id;
    });
  }

  List<Task> getMergedTasks(
    List<Task> lastTasks,
    List<Task> newTasks,
  ) {
    List<Task> list = [];

    final tasks = [...newTasks, ...lastTasks]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (final task in tasks) {
      if (!tasksToId(list).contains(task.id)) {
        list.add(task);
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HomePageHeaderDelegate(
                    orientation == Orientation.portrait ? 200 : 125,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          color: Theme.of(context).shadowColor.withOpacity(0.2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Consumer(
                      builder: (context, ref, child) {
                        ref.watch(appThemeMode);

                        ref.watch(dismissibleTaskListController);
                        List<Task> newtasks =
                            ref.read(sorteredFilteredTaskList);

                        List<String> lastTasksId = tasksToId(lastTasks);

                        List<String> newTasksId = tasksToId(newtasks);

                        List<Task> mergedTasks = getMergedTasks(
                          lastTasks,
                          newtasks,
                        );

                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: mergedTasks.length + 1,
                          itemBuilder: (context, index) {
                            if (index == mergedTasks.length) {
                              return AddTaskCard(
                                onAddTask: ref.read(taskList.notifier).add,
                              );
                            }

                            final task = mergedTasks[index];

                            if (!lastTasksId.contains(task.id) &&
                                newTasksId.contains(task.id)) {
                              return TaskCard(
                                task: task,
                                status: TaskStatus.create,
                              );
                            }

                            if (lastTasksId.contains(task.id) &&
                                !newTasksId.contains(task.id)) {
                              return TaskCard(
                                task: task.edit(done: true),
                                status: TaskStatus.hide,
                              );
                            }

                            return TaskCard(task: task);
                          },
                        );
                      },
                    ),
                  ),
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
