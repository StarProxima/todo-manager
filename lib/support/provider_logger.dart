import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import '../providers/task_providers/task_list_provider.dart';

class ProviderLogger extends ProviderObserver {
  ProviderLogger(this._logger);

  final AppLogger _logger;
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    switch (provider.name) {
      case 'appThemeMode':
        _logger.event('Theme mode changed to $newValue');
        break;
      case 'taskFilter':
        _logger.event('Task filter changed to $newValue');
        break;
      case 'taskList':
        {
          if (provider is! StateNotifierProvider<TaskList, List<Task>>) return;
          final notifier = container.read(
            provider.notifier,
          );
          switch (notifier.lastAction) {
            case TaskListAction.create:
              _logger.event(
                'Task create',
              );
              break;
            case TaskListAction.fastCreate:
              _logger.event(
                'Fast Task create',
              );
              break;
            case TaskListAction.edit:
              if (notifier.lastTask?.done != notifier.originalLastTask?.done) {
                if (notifier.lastTask?.done == true) {
                  _logger.event('Task done');
                } else {
                  _logger.event('Task undone');
                }
              } else {
                _logger.event('Task edit');
              }

              break;
            case TaskListAction.delete:
              _logger.event(
                'Task delete',
              );
              break;
            case TaskListAction.update:
              _logger.event('Tasks update');
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

class AppLogger {
  final bool reportAppMetrica;

  AppLogger({
    this.reportAppMetrica = true,
  });

  Future<void> event(String eventName) async {
    if (reportAppMetrica) {
      await AppMetrica.reportEvent(eventName);
    }
  }
}
