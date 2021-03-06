import 'dart:async';
import 'package:Marbit/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  GlobalKey<InnerDrawerState>? innerDrawerKey;
  GlobalKey<NavigatorState>? navigatorKey;
  bool isDrawerOpen = false;
  late Page navigatorPage;
  late HeroController heroController;
  int? currentPageIndex;

  final List<Page> appPages = [
    const MaterialPage(child: TodaysHabitScreen()),
    const MaterialPage(child: CreateItemScreen()),
    const MaterialPage(child: MyContentScreen()),
  ];

  @override
  void onInit() {
    navigatorPage = const MaterialPage(child: TodaysHabitScreen());
    heroController = HeroController();
    navigatorKey = GlobalKey<NavigatorState>();
    innerDrawerKey = GlobalKey<InnerDrawerState>();
    currentPageIndex = 0;
    super.onInit();
  }

  Future<void> navigateToIndex(int index) async {
    currentPageIndex = index;
    await openDrawer()
        .then((value) => {
              navigatorPage = appPages[index],
              update(),
            })
        .then((value) => innerDrawerKey!.currentState!.close());
  }

  Future<void> openDrawer() async {
    final completer = Completer();
    innerDrawerKey!.currentState!.open();
    if (!isDrawerOpen) {
      await 200.milliseconds.delay();
      return openDrawer();
    } else {
      completer.complete();
    }
    return completer.future;
  }
}
