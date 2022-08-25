import 'package:flutter/foundation.dart';

class NavigationState with ChangeNotifier {
  bool _onHomePage;
  bool _onTaskDetails;

  String? _taskId;

  NavigationState({
    required bool onHomePage,
    required bool onTaskDetails,
    required String? taskId,
  })  : _onHomePage = onHomePage,
        _onTaskDetails = onTaskDetails,
        _taskId = taskId;

  factory NavigationState.fromDTO(NavigationStateDTO dto) {
    return NavigationState(
      onHomePage: dto.onHomePage,
      onTaskDetails: dto.onTaskDetails,
      taskId: dto.taskId,
    );
  }

  bool get onHomePage => _onHomePage;

  set onHomePage(bool val) {
    _onHomePage = val;
    notifyListeners();
  }

  bool get onTaskDetails => _onTaskDetails;

  set onTaskDetails(bool val) {
    _onTaskDetails = val;
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
  bool onTaskDetails;
  String? taskId;
  NavigationStateDTO({
    required this.onHomePage,
    required this.onTaskDetails,
    required this.taskId,
  });
  NavigationStateDTO.homePage()
      : onHomePage = true,
        onTaskDetails = false,
        taskId = null;
  NavigationStateDTO.taskDetails([this.taskId])
      : onHomePage = true,
        onTaskDetails = true;
}
