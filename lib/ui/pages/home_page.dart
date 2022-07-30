import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';
import 'package:todo_manager/ui/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  late Box box;
  Future<void> getTasks() async {
    //tasks = await TaskRepository().getTasks();

    tasks =
        ((await box.get('tasks')) as Iterable).map((e) => e as Task).toList();

    setState(() {});
    print(tasks);
  }

  void addTask() async {
    var task = Task.random();

    tasks.add(task);

    await box.put('tasks', tasks);

    var response = await TaskRepository().addTask(
      task,
    );
    print(response);
    await getTasks();
  }

  void editTask() async {
    if (tasks.isNotEmpty) {
      tasks.last.edit(text: 'Edited text <3');
      log(tasks.last.toString());
      var response = await TaskRepository().editTask(tasks.last);
      await getTasks();
      print(response);
    }
  }

  void deleteTask() async {
    if (tasks.isNotEmpty) {
      box.delete(tasks.last.id);
      var response = await TaskRepository().deleteTask(tasks.last);
      await getTasks();
      print(response);
    }
  }

  void patchTasks() async {
    print(tasks);
    tasks.addAll([]);
    await TaskRepository().patchTasks(tasks);

    await getTasks();
  }

  Future<void> openBox() async {
    box = await Hive.openBox('tasks');
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: getTasks,
                child: const Text('getTasks'),
              ),
              ElevatedButton(
                onPressed: addTask,
                child: const Text('addTask'),
              ),
              ElevatedButton(
                onPressed: editTask,
                child: const Text('editTask'),
              ),
              ElevatedButton(
                onPressed: deleteTask,
                child: const Text('deleteTask'),
              ),
              ElevatedButton(
                onPressed: patchTasks,
                child: const Text('patchTasks'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: tasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
