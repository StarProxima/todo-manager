import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';
import 'package:todo_manager/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Task? lastTask;

  void getTaskList() async {
    final tasks = await TaskRepository().getTasks();

    lastTask = tasks.isNotEmpty ? tasks.last : null;
    print(tasks.toString());
  }

  void addTask() async {
    var response = await TaskRepository().addTask(
      Task(
        importance: Importance.low,
        done: false,
        text: 'way',
      ),
    );
    print(response);
  }

  void editTask() async {
    var response = await TaskRepository().editTask(
      lastTask!.copyWith(
        text: 'NOOO WAAAY',
      ),
    );
    print(response);
  }

  void deleteTask() async {
    var response = await TaskRepository().deleteTask(
      lastTask!,
    );
    print(response);
  }

  void patchTasks() async {
    final tasks = await TaskRepository().getTasks();
    tasks.addAll([
      Task(
        importance: Importance.low,
        done: false,
        text: 'way',
      ),
      Task(
        importance: Importance.low,
        done: false,
        text: 'way',
      ),
    ]);
    print(await TaskRepository().patchTasks(tasks));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}
