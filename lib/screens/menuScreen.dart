import 'package:Marbit/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  final NavigationController navigationController;

  const MenuScreen({Key key, this.navigationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  navigationController.navigateToIndex(0);
                },
                child: Text(
                  "Today",
                  style: Theme.of(context).textTheme.button,
                )),
            TextButton(
                onPressed: () {
                  navigationController.navigateToIndex(1);
                },
                child: Text(
                  "Create",
                  style: Theme.of(context).textTheme.button,
                )),
            TextButton(
                onPressed: () {
                  navigationController.navigateToIndex(2);
                },
                child: Text(
                  "hello".tr,
                  style: Theme.of(context).textTheme.button,
                )),
          ],
        ),
      ),
    );
  }
}
