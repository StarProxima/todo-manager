import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers.dart';
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

  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final transformAnimationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final emptyAnimationController = AnimationController(
    vsync: this,
  );

  // late final deleteAnimationController = AnimationController(
  //   value: 1,
  //   duration: const Duration(milliseconds: 300),
  //   vsync: this,
  // );

  @override
  void initState() {
    super.initState();
    transformAnimationController.addStatusListener((status) {
      if (transformAnimationController.isCompleted) {
        transformAnimationController.reverse();
      }
    });
  }

  List<String> tasksToId(List<Task> list) {
    return List.generate(list.length, (index) {
      return list[index].id;
    });
  }

  List<Task> getMergedTasks(
    List<Task> lastTasks,
    List<Task> newTasks,
    List<Task> allTasks,
  ) {
    List<Task> list = [];

    final tasks = [...newTasks, ...lastTasks]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (final task in tasks) {
      if (!tasksToId(list).contains(task.id)) {
        final t = allTasks.firstWhere((element) => element.id == task.id);
        list.add(t);
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
                        transformAnimationController.reset();
                        transformAnimationController.forward();
                        animationController.reset();
                        animationController.forward();

                        List<String> lastTasksId = tasksToId(lastTasks);

                        List<String> newTasksId = tasksToId(newtasks);

                        List<Task> mergedTasks = getMergedTasks(
                          lastTasks,
                          newtasks,
                          ref.read(taskList),
                        );

                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: mergedTasks.length + 1,
                          itemBuilder: (context, index) {
                            if (index == mergedTasks.length) {
                              return AddTaskCard(
                                onAddTask: onAddTask,
                              );
                            }

                            final task = mergedTasks[index];

                            final taskCard = TaskCard(task: task);

                            if (lastTasksId.contains(task.id) &&
                                !newTasksId.contains(task.id)) {
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: Tween<double>(begin: 1, end: 0)
                                      .animate(animationController),
                                  curve: Curves.easeInOutCubic,
                                ),
                                child: SizeTransition(
                                  sizeFactor: CurvedAnimation(
                                    parent: Tween<double>(begin: 1, end: 0)
                                        .animate(animationController),
                                    curve: Curves.easeOutBack,
                                  ),
                                  child: taskCard,
                                ),
                              );
                            }

                            if (!lastTasksId.contains(task.id) &&
                                newTasksId.contains(task.id)) {
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                  parent: animationController,
                                  curve: Curves.easeInOutCubic,
                                ),
                                child: SizeTransition(
                                  sizeFactor: CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.easeOutBack,
                                  ),
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: const Offset(0, 0),
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animationController,
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                    child: taskCard,
                                  ),
                                ),
                              );
                            }

                            return taskCard;

                            // final lastDate = lastTasks
                            //     .firstWhere(
                            //       (element) => element.id == task.id,
                            //     )
                            //     .changedAt;

                            // final newDate = newtasks
                            //     .firstWhere(
                            //       (element) => element.id == task.id,
                            //     )
                            //     .changedAt;

                            // final isEditedTask = lastDate != newDate;

                            // final animation = Tween<double>(
                            //   begin: 0,
                            //   end: 0.5,
                            // ).animate(
                            //   CurvedAnimation(
                            //     parent: isEditedTask
                            //         ? transformAnimationController
                            //         : emptyAnimationController,
                            //     curve: Curves.decelerate,
                            //   ),
                            // );

                            // return AnimatedBuilder(
                            //   animation: animation,
                            //   child: taskCard,
                            //   builder: (context, child) {
                            //     return Transform(
                            //       alignment: Alignment.center,
                            //       transform: Matrix4.rotationX(animation.value),
                            //       child: child,
                            //     );
                            //   },
                            // );
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
