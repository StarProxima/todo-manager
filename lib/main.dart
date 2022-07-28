import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';

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
    log(tasks.toString());
  }

  void addTask() async {
    var response = await TaskRepository().addTask(
      Task(
        importance: Importance.low,
        done: false,
        text: 'way',
      ),
    );
    log('${response.data} ${response.status}');
  }

  void editTask() async {
    var response = await TaskRepository().editTask(
      lastTask!.copyWith(
        text: 'NOOO WAAAY',
      ),
    );
    log('${response.data} ${response.status}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: getTaskList,
                child: const Text('getTaskList'),
              ),
              ElevatedButton(
                onPressed: addTask,
                child: const Text('addTask'),
              ),
              ElevatedButton(
                onPressed: editTask,
                child: const Text('editTask'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
