import 'dart:async';

import 'package:Marbit/controllers/adController.dart';
import 'package:Marbit/controllers/contentController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  int currentPageIndex = 0;
  GlobalKey<InnerDrawerState> innerDrawerKey;
  bool isDrawerOpen = false;

  @override
  void onInit() {
    innerDrawerKey = GlobalKey<InnerDrawerState>();
    super.onInit();
  }

  Future<void> navigateToIndex(int index) async {
    innerDrawerKey.currentState.open();
    await openDrawer()
        .then((value) => {
              currentPageIndex = index,
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
