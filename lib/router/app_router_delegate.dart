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
    taskId: null,
  );

  bool get onHomePage => state.onHomePage;

  bool get onNewTaskDetails => !state.onHomePage && state.taskId == null;

  bool get onTaskDetails => !state.onHomePage && state.taskId != null;

  MaterialPage? _homePage;

  void gotoHomePage() {
    state = NavigationState(
      onHomePage: true,
      taskId: null,
    );
    notifyListeners();
  }

  void gotoTaskDetails([String? taskId]) {
    state = NavigationState(
      onHomePage: false,
      taskId: taskId,
    );
    notifyListeners();
  }

  @override
  NavigationStateDTO? get currentConfiguration {
    return NavigationStateDTO(state.onHomePage, state.taskId);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();

  @override
  Future<void> setNewRoutePath(NavigationStateDTO configuration) {
    state.taskId = configuration.taskId;
    state.onHomePage = configuration.onHomePage;
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        _homePage ??= MaterialPage(
          child: HomePage(
            key: GlobalKey(),
          ),
        );

        final pages = [
          _homePage!,
          if (!state.onHomePage)
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
