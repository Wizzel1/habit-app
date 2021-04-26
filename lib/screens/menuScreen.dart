import 'package:Marbit/controllers/controllers.dart';
import 'package:Marbit/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
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
          Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
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
                ),
                const SizedBox(height: 30),
                InkWell(
                    onTap: () async {
                      ConsentInformation consentInfo =
                          await FlutterFundingChoices
                              .requestConsentInformation();
                      //TODO add IOS consent
                      if (consentInfo.isConsentFormAvailable &&
                          consentInfo.consentStatus == ConsentStatus.OBTAINED) {
                        await FlutterFundingChoices.showConsentForm();
                        // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      child: Text(
                        'my_content_menutitle'.tr,
                        style: Theme.of(context).textTheme.button,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final Function onTap;
  final String title;
  final Color backGroundColor;
  final Color textColor;

  const MenuItem(
      {Key key, this.onTap, this.title, this.backGroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: InkWell(
            onTap: onTap,
            child: Text(
              title,
              style:
                  Theme.of(context).textTheme.button.copyWith(color: textColor),
            )),
      ),
    );
  }
}
