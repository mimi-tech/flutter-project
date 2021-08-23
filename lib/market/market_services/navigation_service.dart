import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> navigateToWidget(Widget widget) {
    return navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }
}
