import 'dart:async';
import 'dart:developer';

import 'task_local_repository.dart';
import 'task_remote_repository.dart';
import '../models/task_model.dart';
import '../support/logger.dart';

class TaskController {
  late final TaskRemoteRepository _remoteRepository;
  late final TaskLocalRepository _localRepository;

  TaskController({TaskRemoteRepository? remote, TaskLocalRepository? local}) {
    _remoteRepository = remote ?? TaskRemoteRepository();
    _localRepository = local ?? TaskLocalRepository();
  }

  bool checkChanges(List<Task> localTasks, List<Task> serverTasks) {
    bool changes = localTasks.length != serverTasks.length;

    if (!changes) {
      for (int i = 0; i < localTasks.length; i++) {
        if (!localTasks.contains(serverTasks[i])) {
          changes = true;
          break;
        }
      }
    }

    log(changes ? 'unsync data' : 'sync data');

    for (int i = 0; i < localTasks.length; i++) {
      for (int j = i + 1; j < localTasks.length; j++) {
        if (localTasks[i].id == localTasks[j].id) {
          logger.e([localTasks[i], localTasks[j]]);
        }
      }
    }

    return changes;
  }

  Future<List<Task>?> checkTasks(
    List<Task> remoteTasks,
    int revision,
  ) async {
    final tasks = _localRepository.getTasks();

    List<Task> noChanges() {
      log('noChanges');
      _localRepository.saveRevision(revision);
      return remoteTasks;
    }

    List<Task> remoteChanges() {
      log('remoteChanges');
      _localRepository.saveTasks(remoteTasks);
      _localRepository.saveRevision(revision);
      checkChanges(tasks, remoteTasks);
      logger.wtf(remoteTasks);
      return remoteTasks;
    }

    Future<List<Task>?> localChanges() async {
      log('localChanges $revision');
      var response = await _remoteRepository.patchTasks(
        tasks,
        _localRepository.getRevision(),
      );

      if (response.isSuccesful && _remoteRepository.activeRequests == 0) {
        _localRepository.saveTasks(response.data!.data);
        _localRepository.saveRevision(
          response.data!.revision,
        );
        checkChanges(tasks, response.data!.data!);
        logger.e(tasks);
        return response.data!.data!;
      }
      return null;
    }

    if (!checkChanges(tasks, remoteTasks)) {
      return noChanges();
    } else {
      if (_remoteRepository.activeRequests == 0 &&
          _localRepository.getRevision() < revision) {
        return remoteChanges();
      } else {
        return localChanges();
      }
    }
  }

  List<Task> getLocalTasks() {
    return _localRepository.getTasks();
  }

  Future<List<Task>?> getTasks() async {
    var response = await _remoteRepository.getTasks();

    if (response.isSuccesful) {
      print(response.data!.revision);
      return await checkTasks(
        response.data!.data!,
        response.data!.revision!,
      );
    }

    return null;
  }

  Future<List<Task>?> addTask(Task task) async {
    _localRepository.add(task);

    var response = await _remoteRepository.addTask(
      task,
      _localRepository.getRevision(),
    );

    _localRepository.saveRevision(
      response.data?.revision,
    );
    if (response.status == 400) {
      logger.w(response);
      return await getTasks();
    }
    return null;
  }

  Future<List<Task>?> editTask(Task task) async {
    _localRepository.edit(task);

    var response = await _remoteRepository.editTask(
      task,
      _localRepository.getRevision(),
    );

    _localRepository.saveRevision(
      response.data?.revision,
    );
    if (response.status == 400) {
      logger.w(response);
      return await getTasks();
    }
    return null;
  }

  Future<List<Task>?> deleteTask(Task task) async {
    _localRepository.remove(task);

    var response = await _remoteRepository.deleteTask(
      task,
      _localRepository.getRevision(),
    );

    _localRepository.saveRevision(
      response.data?.revision,
    );
    if (response.status == 400) {
      logger.i(response);
      return await getTasks();
    }
    return null;
  }
}
