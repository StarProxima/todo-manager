import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
import '../../main.dart';
import 'widgets/add_task_card.dart';

import '../../models/task_model.dart';
import 'widgets/floating_action_panel.dart';
import 'widgets/home_page_header_delegate.dart';
import 'widgets/task_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  void onEditTask(task) async {
    ref.read(taskList.notifier).edit(task);
  }

  void onDeleteTask(task) async {
    ref.read(taskList.notifier).delete(task);
  }

  void onAddTask(task) async {
    ref.read(taskList.notifier).add(task);
  }

  late final controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  List<String> tasksToId(List<Task> list) {
    return List.generate(list.length, (index) {
      return list[index].id;
    });
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
                        List<Task> tasks = ref.read(filteredTaskList);
                        controller.reset();
                        controller.forward();
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: tasks.length + 1,
                          itemBuilder: (context, index) {
                            if (index == tasks.length) {
                              return AddTaskCard(
                                onAddTask: onAddTask,
                              );
                            }

                            final task = tasks[index];
                            // log(
                            //   tasksToId(lastTasks).contains(task.id).toString(),
                            // );
                            if (!tasksToId(lastTasks).contains(task.id)) {
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: controller,
                                  curve: Curves.easeInOutCubic,
                                ),
                                child: SizeTransition(
                                  sizeFactor: CurvedAnimation(
                                    parent: controller,
                                    curve: Curves.easeOutBack,
                                  ),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: const Offset(0, 0),
                                    ).animate(
                                      CurvedAnimation(
                                        parent: controller,
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                    child: TaskCard(task: task),
                                  ),
                                ),
                              );
                            } else {
                              return TaskCard(task: task);
                            }
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
