import 'package:flutter/foundation.dart';

class NavigationState with ChangeNotifier {
  bool _onHomePage;
  String? _taskId;

  NavigationState({
    required bool onHomePage,
    required String? taskId,
  })  : _onHomePage = onHomePage,
        _taskId = taskId;

  bool get onHomePage => _onHomePage;

  set onHomePage(bool val) {
    _onHomePage = val;
    notifyListeners();
  }

  String? get taskId => _taskId;

  set taskId(String? val) {
    _taskId = val;
    notifyListeners();
  }
}

class NavigationStateDTO {
  bool onHomePage;
  String? taskId;
  NavigationStateDTO(this.onHomePage, this.taskId);
  NavigationStateDTO.homePage()
      : onHomePage = true,
        taskId = null;
  NavigationStateDTO.taskDetails(this.taskId) : onHomePage = false;
}
