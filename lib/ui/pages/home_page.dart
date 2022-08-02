import 'dart:developer';

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
    //tasks = await TaskRepository().getTasks();

    var responce = await TasksManager.getTasks();

    tasks = responce.data ?? tasks;
    setState(() {});
  }

  void addTask() async {
    var task = Task.random();
    setState(() {});
    await TasksManager.addTask(task);

    getTasks();
  }

  void editTask() async {
    if (tasks.isNotEmpty) {
      var task = tasks.last.copyWith();
      task.edit(text: 'Edited text <3');
      await TasksManager.editTask(task);

      getTasks();
    }
  }

  void deleteTask() async {
    if (tasks.isNotEmpty) {
      await TasksManager.deleteTask(tasks.last);

      getTasks();
    }
  }

  Future<void> firstGetTasks() async {
    log('firstGetTasks');
    var responce = TasksManager.getLocalTasks();
    tasks = responce.data ?? tasks;
    setState(() {});
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
                      await TasksManager.deleteTask(tasks[index]);
                      getTasks();
                    },
                    onChangeDone: (done) async {
                      var task = tasks[index].copyWith();
                      task.edit(done: done);
                      await TasksManager.editTask(task);
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
