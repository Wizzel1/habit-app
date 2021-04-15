import 'dart:async';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  GlobalKey<InnerDrawerState> innerDrawerKey;
  bool isDrawerOpen = false;

  List<Page> navigatorPages = [MaterialPage(child: TodaysHabitScreen())];

  List<Page> appPages = [
    MaterialPage(child: TodaysHabitScreen()),
    MaterialPage(child: CreateItemScreen()),
    MaterialPage(child: MyContentScreen()),
  ];

  @override
  void onInit() {
    innerDrawerKey = GlobalKey<InnerDrawerState>();
    super.onInit();
  }

  Future<void> navigateToIndex(int index) async {
    innerDrawerKey.currentState.open();
    await openDrawer()
        .then((value) => {
              navigatorPages = [appPages[index]],
              update(),
            })
        .then((value) => innerDrawerKey.currentState.close());
  }

  Future<void> openDrawer() async {
    final completer = Completer();
    if (!isDrawerOpen) {
      await 200.milliseconds.delay();
      return openDrawer();
    } else {
      completer.complete();
    }
    return completer.future;
  }
}
