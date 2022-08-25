import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../ui/home_page/home_page.dart';
import '../ui/task_details_page/task_details_page.dart';
import 'navigation_state.dart';

class AppRouterDelegate extends RouterDelegate<NavigationStateDTO>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationStateDTO> {
  NavigationState state = NavigationState(
    onHomePage: true,
    onTaskDetails: false,
    taskId: null,
  );

  void gotoHomePage() {
    state = NavigationState(
      onHomePage: true,
      onTaskDetails: false,
      taskId: null,
    );
    notifyListeners();
  }

  void gotoTaskDetails([String? taskId]) {
    state = NavigationState(
      onHomePage: true,
      onTaskDetails: true,
      taskId: taskId,
    );
    notifyListeners();
  }

  @override
  NavigationStateDTO? get currentConfiguration {
    return NavigationStateDTO(
      onHomePage: state.onHomePage,
      onTaskDetails: state.onTaskDetails,
      taskId: state.taskId,
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(NavigationStateDTO configuration) {
    state = NavigationState.fromDTO(configuration);
    return SynchronousFuture(null);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final pages = [
          if (state.onHomePage && !state.onTaskDetails)
            const MaterialPage(
              child: HomePage(),
            ),
          if (state.onTaskDetails)
            MaterialPage(
              child: TaskDetails(
                task: ref.read(taskList.notifier).getTaskById(state.taskId),
              ),
            ),
        ];

        return Navigator(
          onPopPage: (route, result) => route.didPop(result),
          key: navigatorKey,
          pages: pages,
        );
      },
    );
  }
}
