import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers.dart';

import '../models/task_model.dart';

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    switch (provider.name) {
      case 'appThemeMode':
        AppMetrica.reportEvent('Theme mode changed to $newValue');
        break;
      case 'taskFilter':
        AppMetrica.reportEvent('Task filter changed to $newValue');
        break;
      case 'taskList':
        {
          if (provider is! StateNotifierProvider<TaskList, List<Task>>) return;
          final notifier = container.read(
            provider.notifier,
          );
          switch (notifier.lastAction) {
            case TaskListAction.create:
              AppMetrica.reportEvent(
                'Task create',
              );
              break;
            case TaskListAction.fastCreate:
              AppMetrica.reportEvent(
                'Fast Task create',
              );
              break;
            case TaskListAction.edit:
              if (notifier.lastTask?.done != notifier.originalLastTask?.done) {
                if (notifier.lastTask?.done == true) {
                  AppMetrica.reportEvent('Task done');
                } else {
                  AppMetrica.reportEvent('Task undone');
                }
              } else {
                AppMetrica.reportEvent('Task edit');
              }

              break;
            case TaskListAction.delete:
              AppMetrica.reportEvent(
                'Task delete',
              );
              break;
            case TaskListAction.update:
              AppMetrica.reportEvent('Tasks update');
              break;

            case TaskListAction.none:
              break;
          }
        }

        break;
      default:
    }
  }
}
