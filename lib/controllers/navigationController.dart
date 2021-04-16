import 'dart:async';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  GlobalKey<InnerDrawerState> innerDrawerKey;
  GlobalKey<NavigatorState> navigatorKey;
  bool isDrawerOpen = false;

  Page navigatorPage = MaterialPage(child: TodaysHabitScreen());

  final HeroController heroController = HeroController();
  List<Page> appPages = [
    MaterialPage(child: TodaysHabitScreen()),
    MaterialPage(child: CreateItemScreen()),
    MaterialPage(child: MyContentScreen()),
  ];

  @override
  void onInit() {
    navigatorKey = GlobalKey<NavigatorState>();
    innerDrawerKey = GlobalKey<InnerDrawerState>();
    super.onInit();
  }

  Future<void> navigateToIndex(int index) async {
    innerDrawerKey.currentState.open();
    await openDrawer()
        .then((value) => {
              navigatorPage = appPages[index],
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
