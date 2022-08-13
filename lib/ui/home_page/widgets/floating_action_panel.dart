import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/task_model.dart';
import '../../../repositories/tasks_controller.dart';
import '../../task_details_page/task_details_page.dart';

class FloatingActionPanel extends StatelessWidget {
  const FloatingActionPanel({Key? key}) : super(key: key);

  void addRandomTask() async {
    var task = Task.random();
    await TasksController().addTask(task);
  }

  void toDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          onSave: (task) async {
            await TasksController().addTask(task);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: FloatingActionButton(
              heroTag: null,
              mini: true,
              onPressed: () {
                throw Exception('Test crash by button in HomePage');
              },
              child: const Icon(
                Icons.warning,
                size: 25,
              ),
            ),
          ),
        FloatingActionButton(
          heroTag: null,
          onPressed: () => toDetailsPage(context),
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ],
    );
  }
}
