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

    var responce = TasksManager.getLocalTasks();
    tasks = responce.isSuccesful ? responce.data! : [];

    setState(() {});
  }

  void addTask() async {
    var task = Task.random();
    tasks.add(task);
    setState(() {});
    await TasksManager.addTask(task);
    await getTasks();
  }

  void editTask() async {
    if (tasks.isNotEmpty) {
      var task = tasks.last.copyWith();
      task.edit(text: 'Edited text <3');
      print(await TasksManager.editTask(task));

      await getTasks();
    }
  }

  void deleteTask() async {
    if (tasks.isNotEmpty) {
      print(await TasksManager.deleteTask(tasks.last));

      await getTasks();
    }
  }

  void patchTasks() async {
    print(tasks);
    tasks.addAll([]);
  }

  Future<void> firstGetTasks() async {
    var responce = TasksManager.getLocalTasks();
    tasks = responce.isSuccesful ? responce.data! : tasks;
    setState(() {});
    var responce2 = await TasksManager.getTasks();
    print(responce2);
    tasks = responce2.isSuccesful ? responce2.data! : tasks;
  }

  @override
  void initState() {
    super.initState();
    firstGetTasks();
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
                return TaskCard(
                  task: tasks[index],
                  onDelete: () async {
                    tasks.removeAt(index);

                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
