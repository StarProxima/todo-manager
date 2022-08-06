import 'package:flutter/material.dart';
import 'package:todo_manager/data/local/tasks_manager.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/ui/widgets/home_page_header_delegate.dart';

import '../widgets/add_task_card.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  Future<void> getTasks({bool setState = true}) async {
    var responce = await TasksController().getTasks();
    tasks = responce.data ?? tasks;
    if (setState) {
      this.setState(() {});
    } else {
      //  print(tasks.length);
    }
  }

  void addTask() async {
    var task = Task.random();
    var responce = await TasksController().addTask(task);
    getTasks();
  }

  void editTask() async {
    if (tasks.isNotEmpty) {
      var task = tasks.last.editAndCopyWith(text: 'Edited text <3');

      await TasksController().editTask(task);

      getTasks();
    }
  }

  void deleteTask() async {
    if (tasks.isNotEmpty) {
      await TasksController().deleteTask(tasks.last);

      getTasks();
    }
  }

  Future<void> firstGetTasks() async {
    tasks = TasksController().getLocalTasks();
    print(tasks);
    getTasks();
  }

  @override
  void initState() {
    super.initState();
    firstGetTasks();
  }

  bool isd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: HomePageHeaderDelegate(
                completedTaskCount: TasksController().getCompletedTaskCount(),
                onChangeVisibilityCompletedTask: (value) {
                  setState(() {
                    isd = value;
                  });
                },
              ),
              pinned: true,
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
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: tasks.length + 1,
                  itemBuilder: (context, index) {
                    if (index == tasks.length) {
                      return AddTaskCard(
                        onAddTask: (task) async {
                          await TasksController().addTask(task);

                          getTasks();
                        },
                      );
                    }
                    if (isd && tasks[index].done) {
                      return const SizedBox();
                    }
                    return TaskCard(
                      key: ValueKey(tasks[index].id),
                      task: tasks[index],
                      onDelete: (task) async {
                        await TasksController().deleteTask(task);

                        getTasks(setState: false);
                      },
                      onEdit: (task) async {
                        await TasksController().editTask(task);
                        getTasks();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
