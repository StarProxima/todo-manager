import 'dart:developer';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../models/task_model.dart';

void initAppMetrica() {
  AppMetrica.activate(
    const AppMetricaConfig('cba2e9fe-b30a-4c99-b312-cbde3e2dd07f'),
  );
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    switch (provider.name) {
      case 'appThemeMode':
        log('Theme mode changed to $newValue');
        break;
      case 'taskList':
        {
          final action = container
              .read(
                (provider as StateNotifierProvider<TaskList, List<Task>>)
                    .notifier,
              )
              .lastAction;
          switch (action) {
            case TaskListAction.create:
              log('Task created');
              break;
            case TaskListAction.edit:
              log('Task edited');
              break;
            case TaskListAction.delete:
              log('Task deleted');
              break;
            case TaskListAction.update:
              log('Tasks updated');
              break;
          }
        }

        break;
      default:
    }
  }
}
