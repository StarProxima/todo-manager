// Required for code readability when setting a location in the RouteInformation
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import '../models/app_route.dart';
import 'navigation_state.dart';

class AppRouteInformationParser
    extends RouteInformationParser<NavigationStateDTO> {
  @override
  Future<NavigationStateDTO> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final uri = Uri.parse(routeInformation.location ?? '');

    if (uri.pathSegments.length == 1 &&
        uri.pathSegments[0] == AppRoute.homePage.str) {
      return Future.value(
        NavigationStateDTO.homePage(),
      );
    } else if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[1] == AppRoute.taskDetails.str) {
        return Future.value(
          NavigationStateDTO.taskDetails(),
        );
      } else {
        return Future.value(
          NavigationStateDTO.taskDetails(uri.pathSegments[1]),
        );
      }
    }

    return Future.value(NavigationStateDTO.homePage());
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationStateDTO configuration) {
    if (configuration.onHomePage) {
      return RouteInformation(location: '/' + AppRoute.homePage.str);
    } else if (configuration.taskId != null) {
      return RouteInformation(
        location: '/' + AppRoute.homePage.str + '/' + configuration.taskId!,
      );
    } else {
      return RouteInformation(
        location: '/' + AppRoute.homePage.str + '/' + AppRoute.taskDetails.str,
      );
    }
  }
}
