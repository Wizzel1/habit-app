import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/util/util.dart';
import 'package:Marbit/widgets/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuItem(
                  onTap: () => navigationController.navigateToIndex(0),
                  title: 'today_habits_menutitle'.tr,
                  textColor: navigationController.currentPageIndex == 0
                      ? kBackGroundWhite
                      : kLightOrange,
                  backGroundColor: navigationController.currentPageIndex == 0
                      ? kDeepOrange
                      : kBackGroundWhite,
                  isActive: navigationController.currentPageIndex == 0,
                ),
                const SizedBox(height: 30),
                MenuItem(
                  onTap: () => navigationController.navigateToIndex(1),
                  title: 'create_new_menutitle'.tr,
                  textColor: navigationController.currentPageIndex == 1
                      ? kBackGroundWhite
                      : kLightOrange,
                  backGroundColor: navigationController.currentPageIndex == 1
                      ? kDeepOrange
                      : kBackGroundWhite,
                  isActive: navigationController.currentPageIndex == 1,
                ),
                const SizedBox(height: 30),
                MenuItem(
                  onTap: () => navigationController.navigateToIndex(2),
                  title: 'my_content_menutitle'.tr,
                  textColor: navigationController.currentPageIndex == 2
                      ? kBackGroundWhite
                      : kLightOrange,
                  backGroundColor: navigationController.currentPageIndex == 2
                      ? kDeepOrange
                      : kBackGroundWhite,
                  isActive: navigationController.currentPageIndex == 2,
                ),
                //const SizedBox(height: 160),
                // MenuItem(
                //   onTap: () async {
                //     String _url =
                //         'https://github.com/Wizzel1/habit-app/blob/master/privacy-policy.md';
                //     await canLaunch(_url)
                //         ? await launch(_url, forceWebView: true)
                //         : throw 'Could not launch $_url';
                //   },
                //   title: 'Privacy Policy',
                //   textColor: kDeepOrange,
                //   isActive: false,
                // ),
                // const SizedBox(height: 30),
                // InkWell(
                //   onTap: () async {
                //     ConsentInformation consentInfo =
                //         await FlutterFundingChoices.requestConsentInformation();
                //     //TODO add IOS consent
                //     if (consentInfo.isConsentFormAvailable &&
                //         consentInfo.consentStatus == ConsentStatus.OBTAINED) {
                //       await FlutterFundingChoices.showConsentForm();
                //       // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
                //     }
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 8.0, vertical: 10.0),
                //     child: Text(
                //       'my_content_menutitle'.tr,
                //       style: Theme.of(context).textTheme.button,
                //     ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () async {
                //     await Get.find<NotifyController>()
                //         .listScheduledNotifications(context);
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 8.0, vertical: 10.0),
                //     child: Text(
                //       'list all notifications',
                //       style: Theme.of(context).textTheme.button,
                //     ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () async {
                //     await Get.find<NotifyController>()
                //         .utilCancelAllNotifications();
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 8.0, vertical: 10.0),
                //     child: Text(
                //       'cancel all notifications',
                //       style: Theme.of(context).textTheme.button,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final Color? backGroundColor;
  final Color? textColor;
  final bool? isActive;

  const MenuItem(
      {Key? key,
      this.onTap,
      this.title,
      this.backGroundColor,
      this.textColor,
      this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphPressSwitch(
        style: isActive! ? kActiveNeumorphStyle : kInactiveNeumorphStyle,
        onPressed: onTap,
        child: Text(
          title!,
          style: Theme.of(context).textTheme.button!.copyWith(color: textColor),
          textAlign: TextAlign.center,
        ));
  }
}
