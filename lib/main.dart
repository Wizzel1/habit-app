import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Marbit/controllers/navigationController.dart';
import 'package:Marbit/util/util.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.initialize();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      fallbackLocale: Locale('en', 'US'),
      locale: Get.deviceLocale,
      title: 'Marbit',
      theme: orangeTheme(),
      home: InnerDrawerScreen(),
    );
  }
}

class InnerDrawerScreen extends StatefulWidget {
  @override
  _InnerDrawerScreenState createState() => _InnerDrawerScreenState();
}

class _InnerDrawerScreenState extends State<InnerDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: NavigationController(),
        builder: (NavigationController navigationController) {
          return InnerDrawer(
              velocity: 0.5,
              key: navigationController.innerDrawerKey,
              onTapClose: true, // default false
              swipe: true, // default true
              colorTransitionChild: Colors.transparent, // default Color.black54
              colorTransitionScaffold:
                  Colors.transparent, // default Color.black54
              //When setting the vertical offset, be sure to use only top or bottom
              offset: IDOffset.only(bottom: 0.05, right: 0.0, left: 0.0),
              scale:
                  IDOffset.horizontal(0.8), // set the offset in both directions
              proportionalChildArea: true, // default true
              borderRadius: 20, // default 0
              leftAnimationType: InnerDrawerAnimation.static, // default static
              rightAnimationType: InnerDrawerAnimation.quadratic,
              backgroundDecoration: BoxDecoration(
                  color:
                      kLightOrange), // default  Theme.of(context).backgroundColor
              //when a pointer that is in contact with the screen and moves to the right or left
              onDragUpdate: (double val, InnerDrawerDirection direction) {
                // return values between 1 and 0
                // check if the swipe is to the right or to the left
                // print(direction == InnerDrawerDirection.start);
              },
              boxShadow: [],
              innerDrawerCallback: (isDrawerOpen) => {
                    navigationController.isDrawerOpen = isDrawerOpen,
                  }, // return  true (open) or false (close)
              rightChild: MenuScreen(), // required if rightChild is not set
              //rightChild: Container(), // required if leftChild is not set
              //  A Scaffold is generally used but you are free to use other widgets
              // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
              scaffold: Scaffold(
                body: Navigator(
                    onPopPage: (route, result) {
                      if (!route.didPop(result)) return false;
                      return true;
                    },
                    pages: navigationController.navigatorPages),
              )
              /* OR
            CupertinoPageScaffold(                
                navigationBar: CupertinoNavigationBar(
                    automaticallyImplyLeading: false
                ),
            ), 
            */
              );
        });
  }
}
