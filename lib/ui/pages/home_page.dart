import 'package:flutter/material.dart';
import 'package:todo_manager/data/local/tasks_manager.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/ui/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  Future<void> getTasks() async {
    var responce = await TasksController().getTasks();
    print(responce);
    tasks = responce.data ?? tasks;
    setState(() {});
  }

  void addTask() async {
    var task = Task.random();
    var responce = await TasksController().addTask(task);
    print(responce);
    getTasks();
  }

  void editTask() async {
    if (tasks.isNotEmpty) {
      var task = tasks.last.copyWith(text: 'Edited text <3');

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

    getTasks();
  }

  @override
  void initState() {
    super.initState();
    firstGetTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: getTasks,
                  child: const Text('get'),
                ),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text('add'),
                ),
                ElevatedButton(
                  onPressed: editTask,
                  child: const Text('edit'),
                ),
                ElevatedButton(
                  onPressed: deleteTask,
                  child: const Text('delete'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    key: ValueKey(tasks[index].id),
                    task: tasks[index],
                    onDelete: () async {
                      await TasksController().deleteTask(tasks[index]);
                      getTasks();
                    },
                    onChangeDone: (done) async {
                      var task = tasks[index].copyWith(done: done);

                      await TasksController().editTask(task);
                      getTasks();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
