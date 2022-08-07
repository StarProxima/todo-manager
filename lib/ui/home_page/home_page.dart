import 'package:flutter/material.dart';

import '../../models/task_model.dart';
import '../../repositories/tasks_controller.dart';
import '../../support/logger.dart';
import 'widgets/add_task_card.dart';
import 'widgets/floating_action_panel.dart';
import 'widgets/home_page_header_delegate.dart';
import 'widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  ValueNotifier notifier = ValueNotifier(
    TasksController().getCompletedTaskCount(),
  );

  void onEditTask(task) async {
    await TasksController().editTask(task);
  }

  void onDeleteTask(task) async {
    await TasksController().deleteTask(task);
  }

  void onAddTask(task) async {
    await TasksController().addTask(task);
  }

  Future<void> firstGetTasks() async {
    tasks = TasksController().getLocalTasks();
    logger.i(tasks);
    TasksController().getTasks();
  }

  @override
  void initState() {
    super.initState();
    firstGetTasks();
  }

  bool visibilityCompletedTasks = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: HomePageHeaderDelegate(
                visibilityCompletedTask: visibilityCompletedTasks,
                onChangeVisibilityCompletedTask: (value) {
                  setState(() {
                    visibilityCompletedTasks = value;
                  });
                },
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
                child: ValueListenableBuilder(
                  valueListenable: TasksController().getListenableTasksBox(),
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: tasks.length + 1,
                      itemBuilder: (context, index) {
                        if (index == tasks.length) {
                          return AddTaskCard(
                            key: UniqueKey(),
                            onAddTask: onAddTask,
                          );
                        }
                        if (!visibilityCompletedTasks && tasks[index].done) {
                          return SizedBox(
                            key: ValueKey(tasks[index].id),
                          );
                        }
                        return TaskCard(
                          key: ValueKey(tasks[index].id),
                          task: tasks[index],
                          onDeleteTask: onDeleteTask,
                          onEditTask: onEditTask,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionPanel(),
    );
  }
}
