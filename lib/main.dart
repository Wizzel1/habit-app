import 'package:Marbit/bindings/global_controller_bindings.dart';
import 'package:Marbit/screens/screens.dart';
import 'package:Marbit/themes/themes.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get/get.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:workmanager/workmanager.dart';

import 'controllers/controllers.dart';
import 'util/util.dart';
import 'widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: child,
        );
      },
      initialBinding: GlobalControllerBindings(),
      translations: Messages(),
      fallbackLocale: const Locale('en', 'US'),
      locale: Get.deviceLocale,
      title: 'Marbit',
      theme: orangeTheme(),
      home: SplashScreen.navigate(
        name: 'test.riv',
        startAnimation: 'Start',
        loopAnimation: 'Loop',
        endAnimation: 'End',
        until: () async {
          await MobileAds.initialize();
          await Get.find<AdController>().initializeInterstitialAd();
          //await SharedPreferences.getInstance().then((value) => value.clear());
          //await Firebase.initializeApp();
          await Get.find<NotifyController>().initializeNotificationPlugin();
          await Get.find<TutorialController>().loadTutorialInfo();
          await Workmanager()
              .initialize(callbackDispatcher, isInDebugMode: false);
          await Workmanager().registerPeriodicTask(
              "1", "rescheduleNotifications",
              frequency: const Duration(minutes: 375),
              existingWorkPolicy: ExistingWorkPolicy.replace);
        },
        backgroundColor: kBackGroundWhite,
        next: (context) => InnerDrawerScreen(),
      ),
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
          return GetBuilder(
            id: TutorialController.innerDrawerBuilderID,
            builder: (TutorialController tutorialController) {
              return InnerDrawer(
                  velocity: 0.5,
                  key: navigationController.innerDrawerKey,
                  onTapClose: true, // default false
                  swipe: tutorialController
                      .hasFinishedDrawerExtensionStep, // default true
                  colorTransitionChild:
                      Colors.transparent, // default Color.black54
                  colorTransitionScaffold:
                      Colors.transparent, // default Color.black54
                  //When setting the vertical offset, be sure to use only top or bottom
                  offset: const IDOffset.only(), // default true
                  borderRadius: 10, // default 0
                  leftAnimationType:
                      InnerDrawerAnimation.quadratic, // default static
                  rightAnimationType: InnerDrawerAnimation.quadratic,
                  backgroundDecoration: const BoxDecoration(
                      color:
                          kLightOrange), // default  Theme.of(context).backgroundColor
                  //when a pointer that is in contact with the screen and moves to the right or left
                  onDragUpdate: (double val, InnerDrawerDirection direction) {
                    // return values between 1 and 0
                    // check if the swipe is to the right or to the left
                    // print(direction == InnerDrawerDirection.start);
                  },
                  boxShadow: const [],
                  innerDrawerCallback: (isDrawerOpen) => {
                        navigationController.isDrawerOpen = isDrawerOpen,
                      }, // return  true (open) or false (close)
                  rightChild: MenuScreen(), // required if rightChild is not set
                  //rightChild: Container(), // required if leftChild is not set
                  //  A Scaffold is generally used but you are free to use other widgets
                  // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
                  scaffold: Scaffold(
                    body: WillPopScope(
                      onWillPop: () async => !await navigationController
                          .navigatorKey.currentState
                          .maybePop(),
                      child: Navigator(
                          key: navigationController.navigatorKey,
                          observers: [navigationController.heroController],
                          onPopPage: (route, result) {
                            if (!route.didPop(result)) return false;
                            return true;
                          },
                          pages: [navigationController.navigatorPage]),
                    ),
                  )
                  /* OR
              CupertinoPageScaffold(                
                  navigationBar: CupertinoNavigationBar(
                      automaticallyImplyLeading: false
                  ),
              ), 
              */
                  );
            },
          );
        });
  }
}
