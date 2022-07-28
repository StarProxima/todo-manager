import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_manager/data/models/task_model.dart';
import 'package:todo_manager/data/repositories/task_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void getTaskList() async {
    log((await TaskRepository().getTaskList()).toString());
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
            ],
          ),
        ),
      ),
    );
  }
}
