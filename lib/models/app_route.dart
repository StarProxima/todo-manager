enum AppRoute {
  homePage,
  taskDetails,
}

extension AppRouteData on AppRoute {
  String get str {
    switch (this) {
      case AppRoute.homePage:
        return 'home_page';
      case AppRoute.taskDetails:
        return 'task_details';
    }
  }
}
